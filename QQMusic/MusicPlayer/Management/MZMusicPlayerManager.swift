//
//  MZMusicPlayer.swift
//  MyFirstSwiftProject
//
//  Created by 曾龙 on 17/3/25.
//  Copyright © 2017年 scinan. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import CoreMotion
import SDWebImage

//MZMusicPlayer的代理方法
@objc protocol MZMusicPlayerManagerDelegate {
    @objc optional func playMusic(musicItem:MusicItem!)
    @objc optional func loadProgress(progress:Float)
    @objc optional func lyricUpdate(index:NSInteger)
}

class MZMusicPlayerManager: NSObject {
    
    static let shareManager = MZMusicPlayerManager()
    
    var delegate:MZMusicPlayerManagerDelegate?
    var isHasObserver:Bool!
    var musicPlayer:AVPlayer!        //
    var playerItem:AVPlayerItem!
    var musicItem:MusicItem!
    var playerItemList:NSArray!
    var playIndex:NSInteger!
    
    var label:UILabel!
    var imageView:UIImageView!
    var image:UIImage!
    
    var motionManager:CMMotionManager!
    
    //歌词播放时间
    var lyricTime = 0.0
    //第几行歌词
    var lyricLine = 0
    //歌词记时器
    var timer:Timer!
    
    var currentTime:String!{
        get{
            let currentTime:CMTime = (self.musicPlayer.currentItem?.currentTime())!
            let current:TimeInterval = CMTimeGetSeconds(currentTime)
            return String.init(format: "%f", current);
        }
    }
    var durationTime:String!{
        get{
            let durationTime:CMTime = (self.musicPlayer.currentItem?.duration)!
            let duration:TimeInterval = CMTimeGetSeconds(durationTime)
            return String.init(format: "%f", duration);
        }
    }
    
    var currentTimeStr:String!{
        get{
            let currentTime:CMTime = (self.musicPlayer.currentItem?.currentTime())!
            let current:TimeInterval = CMTimeGetSeconds(currentTime)
            if current.isNaN == true {
                return "00:00"
            }
            let currentInt:Int = Int(current)
            return String.init(format: "%.2d:%.2d", currentInt/60,currentInt%60)
        }
    }
    var durationStr:String!{
        get{
            let durationTime:CMTime = (self.musicPlayer.currentItem?.duration)!
            let duration:TimeInterval = CMTimeGetSeconds(durationTime)
            if duration.isNaN == true {
                return "00:00"
            }
            let durationInt:Int = Int(duration)
            return String.init(format: "%.2d:%.2d", durationInt/60,durationInt%60)
        }
    }
    
    func play(){
        if self.musicPlayer == nil {
            return
        }
        self.musicPlayer.play()
    }
    
    func pause(){
        if self.musicPlayer == nil {
            return
        }
        self.musicPlayer.pause()
    }
    
    func playMusic(playList:NSArray,playIndex:NSInteger){
        if self.musicPlayer == nil{
            NotificationCenter.default.addObserver(self, selector: #selector(autoPlayNextMusic), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            self.musicPlayer = AVPlayer.init()
            //  后台播放
            
            let session = AVAudioSession.sharedInstance()
            do { try session.setActive(true) } catch { print(error) }
            do { try session.setCategory(AVAudioSession.Category.playback) } catch { print(error) }
            
            self.motionManager = CMMotionManager.init()
            if self.motionManager.isAccelerometerAvailable {
                print("加速度传感器可用")
                self.motionManager.accelerometerUpdateInterval = 0.2
            } else {
                print("加速度传感器不可用")
            }
            
            self.isHasObserver = false
        }
        
        //延时启动摇晃监听
        self.perform(#selector(startAccelerometer), with: nil, afterDelay: 2)
        
        if self.isHasObserver == true {
            self.currentItemRemoveObserver()
        }
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
        
        self.lyricLine = 0
        self.playIndex = playIndex
        self.playerItemList = playList
        let item:MusicItem = self.playerItemList.object(at: playIndex) as! MusicItem
        self.musicItem = item
        
        let databaseManager = MusicDatabaseManager.share
        databaseManager.insertHistoryMusic(musicItem: item)
        
        //本地歌词
        let lyric = databaseManager.queryLyric(songid: item.id)
        if lyric.count>10 {
            self.analyzeLyric(lyric: lyric)
        } else {
            //获取网络歌词
            MZMusicAPIRequest.getMusicLyric(id: item.id) { (lyric) in
                if lyric != "" {
                    self.analyzeLyric(lyric: lyric)
                    if databaseManager.queryMusicDownload(musicItem: item) {
                        databaseManager.insertMusicLyric(songid: item.id, lyric: lyric)
                    }
                }
            }
        }
        
        let path = MusicDatabaseManager.share.queryDownloadPath(musicItem: musicItem)
        if path.count>10 {
            self.playerItem = AVPlayerItem.init(url: URL.init(fileURLWithPath:path))
        } else {
            //网络音乐
            self.playerItem = AVPlayerItem.init(url: URL.init(string: item.url!)!)
        }

        
        self.musicPlayer.replaceCurrentItem(with: self.playerItem)
        self.musicPlayer.volume = 1;
        self.musicPlayer.play()
        
        self.currentItemAddObserver()
        
        if self.delegate?.playMusic != nil {
            self.delegate?.playMusic!(musicItem: self.musicItem)
        }

        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateLyric), userInfo: nil, repeats: true)
    }
    
    
    //解析歌词
    func analyzeLyric(lyric:String) {
        let musicTimes = NSMutableArray.init()
        let lyrics = NSMutableArray.init()
        
        var arr = lyric.components(separatedBy: CharacterSet.init(charactersIn: "[]"))
        for i in stride(from: 11, to: arr.count, by: 2) {
            let timeString:String = arr[i]
            let lyric:String = arr[i+1].replacingOccurrences(of: "\n", with: "");
            let timeArray = timeString.components(separatedBy: ":")
            let minute = Double(timeArray[0])!;
            let second = Double(timeArray[1])!;
            let time = minute*60 + second;
            if (lyric.count > 0) {
                musicTimes.add(time)
                lyrics.add(lyric)
            }
        }
        
        self.musicItem.musicLyricLyrics = lyrics
        self.musicItem.musicLyricTimes = musicTimes
    }
    
    //开始摇晃监听
    @objc func startAccelerometer()  {
        self.motionManager.startAccelerometerUpdates(to: OperationQueue.init()) { (accelerometerData, error) in
            let acceleration = accelerometerData?.acceleration
            let accelerameter = sqrt(pow((acceleration?.x)!, 2)+pow((acceleration?.y)!, 2)+pow((acceleration?.z)!, 2))
            if accelerameter>5 {
                self.motionManager.stopAccelerometerUpdates()
                //回到主线程
                DispatchQueue.main.sync(execute: {
                    self.playNextMusic()
                })
            }
        }
    }
    
    func updateMusicWithCurrentTime(currentTime:Float) {
        let time = CMTimeMake(value: Int64(currentTime),timescale: 1)
        self.musicPlayer.seek(to: time)
        self.lyricLine = 0
    }
    
    @objc func updateLyric()  {
        
        self.updateCurrentTime()
        
        if self.musicItem.musicLyricTimes == nil {
            if self.delegate?.lyricUpdate != nil{
                self.delegate?.lyricUpdate!(index: -1)
                return
            }
        }
        let currentTime = self.musicPlayer.currentItem?.currentTime()
        let time1:TimeInterval = CMTimeGetSeconds(currentTime!)
        for j in self.lyricLine..<(self.musicItem.musicLyricLyrics?.count)! {
            let time2:Double = self.musicItem.musicLyricTimes!.object(at: j) as! Double
            if (time1>time2){
                self.lyricLine = j
                if self.delegate?.lyricUpdate != nil {
                    self.delegate?.lyricUpdate!(index: self.lyricLine)
                }
            }
        }
    }
    
    func playPreMusic() {
        if self.playerItemList != nil {
            self.playMusic(playList: self.playerItemList, playIndex: (self.playIndex-1+self.playerItemList.count)%self.playerItemList.count)
        }
    }
    
    func playNextMusic() {
        if self.playerItemList != nil {
            self.playMusic(playList: self.playerItemList, playIndex: (self.playIndex+1)%self.playerItemList.count)
        }
    }
    
    @objc func autoPlayNextMusic() {
        let mode =  UserDefaults.standard.value(forKey: "musicPlayMode")
        if  mode == nil || (mode as! Bool == true){
            self.playNextMusic()
        } else {
            self.playMusic(playList: self.playerItemList, playIndex: self.playIndex)
        }
        
    }
    
    func setupPlayMode(isCircle:Bool) {
        UserDefaults.standard.set(isCircle, forKey: "musicPlayMode")
        UserDefaults.standard.synchronize()
    }
    
    /// 移除监听
    func currentItemRemoveObserver() {
        self.musicPlayer.currentItem?.removeObserver(self, forKeyPath: "status")
        self.musicPlayer.currentItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        self.musicPlayer.removeObserver(self, forKeyPath: "rate")
        self.isHasObserver = false
    }
    
    func currentItemAddObserver() {
        self.musicPlayer.currentItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        self.musicPlayer.currentItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        self.musicPlayer.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil)
        self.isHasObserver = true
    }
    
    func updateCurrentTime() {
        let backGround = UserDefaults.standard.value(forKey: "backGround")
        if backGround != nil {
            if (backGround as! String) == "1"{
                var info = [String:NSObject]()
                let item:MusicItem = self.playerItemList.object(at: self.playIndex) as! MusicItem
                info.updateValue(item.name as NSObject, forKey:MPMediaItemPropertyTitle)
                info.updateValue(item.singer as NSObject, forKey:MPMediaItemPropertyArtist)
                info.updateValue(self.currentTime as NSObject, forKey: MPNowPlayingInfoPropertyElapsedPlaybackTime)
                info.updateValue(self.durationTime as NSObject, forKey: MPMediaItemPropertyPlaybackDuration)
                info.updateValue("\(self.musicPlayer.rate)" as NSObject, forKey: MPNowPlayingInfoPropertyPlaybackRate)
                if self.musicItem.musicLyricLyrics == nil {
                    let imageView = UIImageView.init()
                    imageView.sd_setImage(with: URL.init(string: self.musicItem.pic!), placeholderImage: UIImage.init(named: "QQListBack"), options: SDWebImageOptions.retryFailed, completed: { (loadImage, error, cacheType, url) in
                        if loadImage != nil {
                            info.updateValue(MPMediaItemArtwork.init(image: loadImage!), forKey: MPMediaItemPropertyArtwork)
                            MPNowPlayingInfoCenter.default().nowPlayingInfo = info
                        }
                    })
                } else {
                    var lineLRC = self.musicItem.musicLyricLyrics?.object(at: self.lyricLine)
                    if self.label == nil {
                        self.label = UILabel.init(frame: CGRect.init(x: 20*3, y: 180*3, width: 200*3, height: 40*3))
                        self.label.backgroundColor = UIColor.clear
                        self.label.textColor = UIColor.white
                        self.label.textAlignment = NSTextAlignment.center
                        self.label.font = UIFont.systemFont(ofSize: 10*3)
                        self.label.numberOfLines = 3
                        self.label.text = ""
                    }
                    
                    if lineLRC as?String == self.label.text {
                        return
                    }
                    
                    if self.lyricLine == 0 {
                        lineLRC = NSMutableString.init(string: "\n")
                        (lineLRC as? NSMutableString)?.append(self.musicItem.musicLyricLyrics?.object(at: 0) as! String)
                        (lineLRC as? NSMutableString)?.append("\n")
                        (lineLRC as? NSMutableString)?.append(self.musicItem.musicLyricLyrics?.object(at: 1) as! String)
                    } else if(self.lyricLine == (self.musicItem.musicLyricLyrics?.count)!-1){
                        lineLRC = NSMutableString.init(string: self.musicItem.musicLyricLyrics?.object(at: self.lyricLine-1) as! String)
                        (lineLRC as? NSMutableString)?.append("\n")
                        (lineLRC as? NSMutableString)?.append(self.musicItem.musicLyricLyrics?.object(at: self.lyricLine) as! String)
                        (lineLRC as? NSMutableString)?.append("\n")
                    } else {
                        lineLRC = NSMutableString.init(string: self.musicItem.musicLyricLyrics?.object(at: self.lyricLine-1) as! String)
                        (lineLRC as? NSMutableString)?.append("\n")
                        (lineLRC as? NSMutableString)?.append(self.musicItem.musicLyricLyrics?.object(at: self.lyricLine) as! String)
                        (lineLRC as? NSMutableString)?.append("\n")
                        (lineLRC as? NSMutableString)?.append(self.musicItem.musicLyricLyrics?.object(at: self.lyricLine+1) as! String)
                    }
                    let str = NSMutableAttributedString.init(string: lineLRC as! String)
                    let range:NSRange = ((lineLRC as? NSString)?.range(of: self.musicItem.musicLyricLyrics!.object(at: self.lyricLine) as! String))!
                    str.setAttributes([NSAttributedString.Key.foregroundColor:MainColor], range: range)
                    
                    self.label.attributedText = str
                    
                    if self.imageView == nil {
                        self.imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 240*3, height: 240*3))
                    }
                    self.imageView.sd_setImage(with: URL.init(string: self.musicItem.pic!), placeholderImage: UIImage.init(named: "QQListBack"), options: SDWebImageOptions.retryFailed) { (loadImage, error, cacheType, url) in
                        if self.imageView.subviews.count == 0 {
                            self.imageView.addSubview(self.label)
                        }
                        
                        UIGraphicsBeginImageContext(self.imageView.frame.size)
                        let context = UIGraphicsGetCurrentContext()
                        self.imageView.layer.render(in: context!)
                        self.image = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()
                        info.updateValue(MPMediaItemArtwork.init(image: self.image), forKey: MPMediaItemPropertyArtwork)
                        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
                    }
                }
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard object is AVPlayerItem else {
            if keyPath == "rate" {
                let item = object as! AVPlayer
                if item.rate == 0 {
                    UserDefaults.standard.set(self.currentTime, forKey: "currentTime")
                    UserDefaults.standard.set(self.playIndex, forKey: "playIndex")
                    let musicListData = NSKeyedArchiver.archivedData(withRootObject: self.playerItemList as Any)
                    UserDefaults.standard.set(musicListData, forKey: "musicList")
                    UserDefaults.standard.synchronize()
                }
            }
            return
        }
        let item = object as! AVPlayerItem
        if keyPath == "status" {
//            if item.status == AVPlayerItemStatus.readyToPlay {
//                self.musicPlayer.play()
//            } else if item.status == AVPlayerItemStatus.failed {
//                self.musicPlayer.pause()
//            }
        } else if keyPath == "loadedTimeRanges" {
            let array = item.loadedTimeRanges
            guard let timeRange = array.first?.timeRangeValue else {return}  //  缓冲时间范围
            let totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration)    //  当前缓冲长度
            let tmpTime = CGFloat(totalBuffer)
            let durationTime:CMTime = (self.musicPlayer.currentItem?.duration)!
            let duration:TimeInterval = CMTimeGetSeconds(durationTime)
            let tmpProgress = tmpTime/CGFloat(duration)
            if ((self.delegate?.loadProgress) != nil) {
                self.delegate?.loadProgress!(progress: Float(tmpProgress))
            }
        }
    }
    
}
