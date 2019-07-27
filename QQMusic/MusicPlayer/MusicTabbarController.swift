//
//  MusicTabbarController.swift
//  MyFirstSwiftProject
//
//  Created by 曾龙 on 17/4/1.
//  Copyright © 2017年 scinan. All rights reserved.
//

import UIKit
import AVFoundation

class MusicTabbarController: UITabBarController,MZMusicPlayerManagerDelegate {
    
    var playBtn:UIButton!
    var iconView:UIImageView!
//    var musicNameLB:UILabel!
    var musicNameLB:MZMarqueeLabel!
    var musicAuthorLB:UILabel!
    var circleView:MZCircleProgress!
    var musicList:NSArray!
    
    var playerView:UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let manager = MZMusicPlayerManager.shareManager
        manager.delegate = self
        if manager.musicItem != nil {
            let item:MusicItem = manager.musicItem
            let imgData = MusicDatabaseManager.share.querySmallAlbumImage(songid: item.songid)
            if imgData != nil {
                self.iconView.image = UIImage.init(data: imgData!)
            } else {
                self.iconView.sd_setImage(with: URL.init(string: item.albumpic_small!), placeholderImage: UIImage.init(named: "QQListBack"))
            }
            self.musicNameLB.setBackgroundColr(backgroundColr: UIColor.clear, text: manager.musicItem.songname, font: UIFont.systemFont(ofSize: 16), textColor: MainColor,textAlignment:NSTextAlignment.left)
            self.musicAuthorLB.text = manager.musicItem.singername
            if manager.musicPlayer.rate>0 {
                self.iconView.layer.removeAllAnimations()
                let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
                rotationAnimation.toValue = 2.0*Double.pi
                rotationAnimation.duration = 5
                rotationAnimation.isCumulative = true
                rotationAnimation.repeatCount = Float.greatestFiniteMagnitude;
                self.iconView.layer.add(rotationAnimation, forKey: "rotationAnimation")
            }
        }
        self.perform(#selector(updateMusicListTable), with: nil, afterDelay: 0.1)
    }
    
    //更新当前界面的音乐界面播放歌曲的选中状态
    @objc public func updateMusicListTable()  {
        
        if self.children.count>0 {
            let manager = MZMusicPlayerManager.shareManager
            let musicItem = manager.musicItem
            let vc = self.children.first
            
            for vc1 in (vc?.children)! {
                if vc1.classForCoder == MusicTop100VC.classForCoder() {
                    let topVC:MusicTop100VC = vc1 as! MusicTop100VC
                    if topVC.musicList != nil && manager.playerItemList != nil {
                        for i in 0..<topVC.musicList.count {
                            let item:MusicItem = topVC.musicList.object(at: i) as! MusicItem
                            if item.songid == musicItem?.songid {
                                topVC.tableView.selectRow(at: IndexPath.init(row: i, section: 0), animated: false, scrollPosition: UITableView.ScrollPosition.none)
                                return
                            }
                        }
                        topVC.tableView.reloadData()
                    }
                }

                if vc1.classForCoder == MusicDownloadVC.classForCoder() {
                    let downloadVC:MusicDownloadVC = vc1 as! MusicDownloadVC
                    if downloadVC.taskList != nil && manager.playerItemList != nil {
                        for i in 0..<downloadVC.taskList.count {
                            let task:DownloadTask = downloadVC.taskList.object(at: i) as! DownloadTask
                            let fileName = task.url.lastPathComponent
                            let arr = fileName.components(separatedBy: ".")
                            if arr[0] == musicItem?.songid {
                                downloadVC.tableView.selectRow(at: IndexPath.init(row: i, section: 0), animated: false, scrollPosition: UITableView.ScrollPosition.none)
                                return
                            }
                        }
                        downloadVC.tableView.reloadData()
                    }
                }
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let playerView:UIView = UIView.init(frame: CGRect.init(x: 0, y: SCREEN_HEIGHT-49, width: SCREEN_WIDTH, height: 49))
        playerView.backgroundColor = UIColor.init(red: 244/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1)
        self.view.addSubview(playerView)
        playerView.isUserInteractionEnabled = true
        self.playerView = playerView
        
        self.iconView = UIImageView.init(frame: CGRect.init(x: 10, y: 5, width: 40, height: 40))
        self.iconView.layer.cornerRadius = 20
        self.iconView.layer.masksToBounds = true
        playerView.addSubview(self.iconView)
        self.iconView.isUserInteractionEnabled = true
        
        //点击图像进入歌词界面
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(showLyricView))
        self.iconView.addGestureRecognizer(tap)
        
        //左滑上一曲
        let leftSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(musicPrePlay))
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        playerView.addGestureRecognizer(leftSwipe)
        
        //右滑下一曲
        let rightSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(musicNextPlay))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        playerView.addGestureRecognizer(rightSwipe)
        
        self.musicNameLB = MZMarqueeLabel.init(frame: CGRect.init(x: 60, y: 5, width: 180, height: 20))
        playerView.addSubview(self.musicNameLB)
        
        self.musicAuthorLB = UILabel.init(frame: CGRect.init(x: 60, y: 25, width: 180, height: 20))
        self.musicAuthorLB.textColor = MainColor
        self.musicAuthorLB.font = UIFont.systemFont(ofSize: 12)
        playerView.addSubview(self.musicAuthorLB)
        
        
        let btn3:UIButton = UIButton.init(type: UIButton.ButtonType.custom)
        btn3.frame = CGRect.init(x: 270, y: 10, width: 30, height: 30)
        btn3.setBackgroundImage(UIImage.init(named: "player_btn_play_normal"), for: UIControl.State.normal)
        btn3.setBackgroundImage(UIImage.init(named: "player_btn_pause_normal"), for: UIControl.State.selected)
        btn3.addTarget(self, action:#selector(musicPlayOrPause(sender:)), for: UIControl.Event.touchUpInside)
        playerView.addSubview(btn3)
        self.playBtn = btn3
        
        self.addCircleView()
        
        let currentTime = UserDefaults.standard.string(forKey: "currentTime")
        let playIndex = UserDefaults.standard.integer(forKey: "playIndex")
        let musicListData = UserDefaults.standard.data(forKey: "musicList")
        if musicListData != nil {
            self.musicList = NSKeyedUnarchiver.unarchiveObject(with: musicListData!) as! NSArray?
        }
        if currentTime != nil{
            let manager = MZMusicPlayerManager.shareManager
            manager.delegate = self
            manager.playMusic(playList: self.musicList, playIndex: playIndex)
            let time = CMTimeMake(value: Int64(Float(currentTime!)!),timescale: 1)
            manager.musicPlayer.seek(to: time)
            manager.pause()
        }
    }
    
    func addCircleView() {
        if self.circleView != nil {
            self.circleView.removeFromSuperview()
            self.circleView = nil
        }
        
        let circleView = MZCircleProgress.init(frame: CGRect.init(x: 270, y: 10, width: 30, height: 30))
        circleView.backLineColor = UIColor.clear
        circleView.backLineWidth = 3
        circleView.progressLineColor = MainColor
        circleView.progressLineWidth = 3
        circleView.backgroundColor = UIColor.clear
        playerView.insertSubview(circleView, belowSubview: self.playBtn)
        self.circleView = circleView
    }
    
    @objc func showLyricView() {
        let vc = MusicLyricVC()
        let nav:MZNavigationController = MZNavigationController()
        nav.addChild(vc)
        self.present(nav, animated: true, completion: nil)
    }

    @objc func musicPrePlay() {
        MZMusicPlayerManager.shareManager.playPreMusic()
    }
    
    @objc func musicNextPlay() {
        MZMusicPlayerManager.shareManager.playNextMusic()
    }
    
    @objc func musicPlayOrPause(sender:UIButton) {
        let manager = MZMusicPlayerManager.shareManager
        if sender.isSelected {
            manager.pause()
        } else {
            manager.play()
        }
    }
    
    func updateWithMusicPause() {
        self.playBtn.isSelected = false
        let pauseTime = self.iconView.layer.convertTime(CACurrentMediaTime(), from: nil)
        self.iconView.layer.timeOffset = pauseTime
        self.iconView.layer.speed = 0
    }
    
    func updateWithMusicPlay() {
        self.playBtn.isSelected = true
        
        let pauseTime = self.iconView.layer.timeOffset
        let timeSincePause = CACurrentMediaTime()-pauseTime
        self.iconView.layer.timeOffset = 0
        self.iconView.layer.beginTime = timeSincePause
        self.iconView.layer.speed = 1
    }
    
    func lyricUpdate(index: NSInteger) {
        let manager = MZMusicPlayerManager.shareManager
        if manager.currentTime == nil {
            self.circleView.ratio = 0
        } else {
            if self.circleView != nil{
                self.circleView.ratio = CGFloat(Float(manager.currentTime)!)/CGFloat(Float(manager.durationTime)!)
            }
        }
        
        if (self.iconView.layer.animation(forKey: "rotationAnimation") == nil) && manager.musicPlayer.rate>0 {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.toValue = 2.0*Double.pi
            rotationAnimation.duration = 5
            rotationAnimation.isCumulative = true
            rotationAnimation.repeatCount = Float.greatestFiniteMagnitude;
            self.iconView.layer.add(rotationAnimation, forKey: "rotationAnimation")
        }
        
        
        if manager.musicPlayer.rate == 0 {
            if self.playBtn.isSelected == false {
                return;
            }
            self.updateWithMusicPause()
        } else {
            if self.playBtn.isSelected == true {
                return;
            }
            self.updateWithMusicPlay()
        }
    }
    
    func playMusic(musicItem: MusicItem) {
        self.musicAuthorLB.text = musicItem.singername
        self.addCircleView()
        self.musicNameLB.setBackgroundColr(backgroundColr: UIColor.clear, text: musicItem.songname, font: UIFont.systemFont(ofSize: 16), textColor: MainColor,textAlignment:NSTextAlignment.left)
        
        let imgData = MusicDatabaseManager.share.querySmallAlbumImage(songid: musicItem.songid)
        if imgData != nil {
            self.iconView.image = UIImage.init(data: imgData!)
        } else {
            self.iconView.sd_setImage(with: URL.init(string: musicItem.albumpic_small!), placeholderImage: UIImage.init(named: "QQListBack"))
        }
        self.updateMusicListTable()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
