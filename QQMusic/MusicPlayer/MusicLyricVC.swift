//
//  MusicLyricVC.swift
//  MyFirstSwiftProject
//
//  Created by 曾龙 on 17/3/27.
//  Copyright © 2017年 scinan. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

enum TableViewType:Int {
    case lyricTable
    case musicTable
    case subLyricTable
}

class MusicLyricVC: UIViewController,UITableViewDelegate,UITableViewDataSource,MZMusicPlayerManagerDelegate,UIGestureRecognizerDelegate {

    var tableView:UITableView!
    var subLyricTableView:UITableView!
    var musicItem:MusicItem!
    var playBtn:UIButton!
    var progressView:UISlider!
    var currentTimeLB:UILabel!
    var durationLB:UILabel!
    var bgView:UIImageView!
    
    var noLyricLB1:UILabel!
    var noLyricLB2:UILabel!
    
    var authorLB:UILabel!
    var albumImageView:UIImageView!
    
    var rightView:UIView!
    
    var titleLB:MZMarqueeLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateAlbumAnimation), name:UIApplication.didBecomeActiveNotification, object: nil)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        let manager = MZMusicPlayerManager.shareManager
        self.musicItem = manager.musicItem
        manager.delegate = self
        
        let titleBGView = UIView.init(frame: CGRect.init(x: 60, y: 0, width: 200, height: 44))
        titleBGView.backgroundColor = UIColor.clear
        self.titleLB = MZMarqueeLabel.init(frame: CGRect.init(x: 0, y: 10, width: 200, height: 24))
        titleBGView.addSubview(self.titleLB)
        self.navigationController?.navigationBar.addSubview(titleBGView)
        self.titleLB.setBackgroundColr(backgroundColr: UIColor.clear, text: self.musicItem.title, font: UIFont.systemFont(ofSize: 18), textColor: UIColor.white,textAlignment:NSTextAlignment.center)
        
        self.bgView = UIImageView.init(frame: self.view.bounds)
        self.view.addSubview(self.bgView)
        
        //创建背景毛玻璃效果
        let blurEffect  = UIBlurEffect.init(style: UIBlurEffect.Style.light)
        let blurView = UIVisualEffectView.init(effect: blurEffect)
        blurView.frame.size = CGSize.init(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        let vibrancyView = UIVisualEffectView.init(effect: UIVibrancyEffect.init(blurEffect: blurEffect))
        vibrancyView.frame.size = CGSize.init(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        blurView.contentView.addSubview(vibrancyView)
        self.view.addSubview(blurView)
        
        let playerView:UIView = UIView.init(frame: CGRect.init(x: 0, y: SCREEN_HEIGHT-100, width: SCREEN_WIDTH, height: 100))
        playerView.backgroundColor = UIColor.clear
        self.view.addSubview(playerView)
        
        self.progressView = UISlider.init(frame: CGRect.init(x: 50, y: 20, width: SCREEN_WIDTH-100, height: 10))
        self.progressView.minimumTrackTintColor = MainColor
        self.progressView.maximumTrackTintColor = UIColor.gray
        self.progressView.setThumbImage(UIImage.init(named: "player_slider_playback_thumb"), for: UIControl.State.normal)
        playerView.addSubview(self.progressView)
        self.progressView.addTarget(self, action: #selector(updateMusicProgress(slider:)), for: UIControl.Event.valueChanged)
        
        self.currentTimeLB = UILabel.init(frame: CGRect.init(x: 10, y: 20, width: 40, height: 10))
        self.currentTimeLB.textAlignment = NSTextAlignment.center
        self.currentTimeLB.backgroundColor = UIColor.clear
        self.currentTimeLB.textColor = UIColor.white
        self.currentTimeLB.font = UIFont.systemFont(ofSize: 10)
        playerView.addSubview(self.currentTimeLB)
        
        self.durationLB = UILabel.init(frame: CGRect.init(x: SCREEN_WIDTH-50, y: 20, width: 40, height: 10))
        self.durationLB.textAlignment = NSTextAlignment.center
        self.durationLB.backgroundColor = UIColor.clear
        self.durationLB.textColor = UIColor.white
        self.durationLB.font = UIFont.systemFont(ofSize: 10)
        playerView.addSubview(self.durationLB)
        
        self.progressView.value = Float(manager.currentTime)!/Float(manager.durationTime)!
        self.currentTimeLB.text = manager.currentTimeStr
        self.durationLB.text = manager.durationStr
        
        let modeBtn:UIButton = UIButton.init(type: UIButton.ButtonType.custom)
        modeBtn.backgroundColor = UIColor.clear;
        modeBtn.frame = CGRect.init(x: 10, y: 45, width: 40, height: 40)
        modeBtn.setTitle("列表", for: UIControl.State.normal)
        modeBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        modeBtn.setTitle("单曲", for: UIControl.State.selected)
        modeBtn.setTitleColor(UIColor.white, for: UIControl.State.selected)
        modeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        modeBtn.addTarget(self, action:#selector(changeMusicPlayMode(sender:)), for: UIControl.Event.touchUpInside)
        playerView.addSubview(modeBtn)
        
        let mode =  UserDefaults.standard.value(forKey: "musicPlayMode")
        if  mode == nil || (mode as! Bool == true){
            modeBtn.isSelected = false
        } else {
            modeBtn.isSelected = true
        }
        
        
        let btn1:UIButton = UIButton.init(type: UIButton.ButtonType.custom)
        btn1.frame = CGRect.init(x: 60, y: 40, width: 50, height: 50)
        btn1.setBackgroundImage(UIImage.init(named: "player_btn_pre_normal"), for: UIControl.State.normal)
        btn1.setBackgroundImage(UIImage.init(named: "player_btn_pre_highlight"), for: UIControl.State.highlighted)
        btn1.addTarget(self, action:#selector(musicPrePlay), for: UIControl.Event.touchUpInside)
        playerView.addSubview(btn1)
        
        let btn3:UIButton = UIButton.init(type: UIButton.ButtonType.custom)
        btn3.frame = CGRect.init(x: 135, y: 40, width: 50, height: 50)
        btn3.setBackgroundImage(UIImage.init(named: "player_btn_play_normal"), for: UIControl.State.normal)
        btn3.setBackgroundImage(UIImage.init(named: "player_btn_pause_normal"), for: UIControl.State.selected)
        btn3.addTarget(self, action:#selector(musicPlayOrPause(sender:)), for: UIControl.Event.touchUpInside)
        playerView.addSubview(btn3)
        self.playBtn = btn3
        
        let btn2:UIButton = UIButton.init(type: UIButton.ButtonType.custom)
        btn2.frame = CGRect.init(x: 210, y: 40, width: 50, height: 50)
        btn2.setBackgroundImage(UIImage.init(named: "player_btn_next_normal"), for: UIControl.State.normal)
        btn2.setBackgroundImage(UIImage.init(named: "player_btn_next_highlight"), for: UIControl.State.highlighted)
        btn2.addTarget(self, action:#selector(musicNextPlay), for: UIControl.Event.touchUpInside)
        playerView.addSubview(btn2)
        
        let btn4:UIButton = UIButton.init(type: UIButton.ButtonType.custom)
        btn4.frame = CGRect.init(x: 270, y: 45, width: 40, height: 40)
        btn4.setBackgroundImage(UIImage.init(named: "main_tab_more"), for: UIControl.State.normal)
        btn4.setBackgroundImage(UIImage.init(named: "main_tab_more_h"), for: UIControl.State.highlighted)
        btn4.addTarget(self, action:#selector(showMusicList), for: UIControl.Event.touchUpInside)
        playerView.addSubview(btn4)
        
        let backBtn:UIButton = UIButton.init(type: UIButton.ButtonType.custom)
        backBtn.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        backBtn.setImage(UIImage.init(named: "miniplayer_btn_playlist_close_b"), for: UIControl.State.normal)
        backBtn.setImage(UIImage.init(named: "miniplayer_btn_playlist_close"), for: UIControl.State.highlighted)
        backBtn.addTarget(self, action: #selector(dissmissVC), for: UIControl.Event.touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)
        
        let volume:MPVolumeView = MPVolumeView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        volume.showsVolumeSlider = false
        volume.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: volume)
        
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-164))
        scrollView.backgroundColor = UIColor.clear
        scrollView.contentSize = CGSize.init(width: SCREEN_WIDTH*2, height: SCREEN_HEIGHT-164)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollView)
        
        let albumView = UIView.init(frame: CGRect.init(x: 0, y: 10, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-184))
        albumView.backgroundColor = UIColor.clear
        scrollView.addSubview(albumView)

        self.authorLB = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 30))
        self.authorLB.text = self.musicItem.getSingerName()
        self.authorLB.backgroundColor = UIColor.clear
        self.authorLB.textAlignment = NSTextAlignment.center
        self.authorLB.textColor = UIColor.white
        albumView.addSubview(self.authorLB)
        
        self.albumImageView = UIImageView.init(frame: CGRect.init(x: 50, y: 40, width: SCREEN_WIDTH-100, height: SCREEN_WIDTH-100))
        let imgData = MusicDatabaseManager.share.queryLargeAlbumImage(songid: musicItem.mid)
        if imgData != nil {
            self.albumImageView.image = UIImage.init(data: imgData!)
            self.bgView.image = UIImage.init(data: imgData!)
        } else {
            self.albumImageView.sd_setImage(with: URL.init(string: musicItem.getAblumUrl()), placeholderImage: UIImage.init(named: "QQListBack"))
            self.bgView.sd_setImage(with: URL.init(string: musicItem.getAblumUrl()), placeholderImage: UIImage.init(named: "QQListBack"))
        }
        self.albumImageView.layer.cornerRadius = (SCREEN_WIDTH-100)*0.5
        self.albumImageView.layer.masksToBounds = true
        albumView.addSubview(self.albumImageView)
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.toValue = 2.0*Double.pi
        rotationAnimation.duration = 5
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = Float.greatestFiniteMagnitude
        self.albumImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
        
        
        self.subLyricTableView = UITableView.init(frame: CGRect.init(x: 0, y: SCREEN_WIDTH-50, width: SCREEN_WIDTH, height: 143), style: UITableView.Style.plain)
        self.subLyricTableView.backgroundColor = UIColor.clear
        self.subLyricTableView.delegate = self
        self.subLyricTableView.dataSource = self
        self.subLyricTableView.tag = TableViewType.subLyricTable.rawValue
        self.subLyricTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        albumView.addSubview(self.subLyricTableView)
        //是歌词起始都在中间位置
        self.subLyricTableView.contentInset = UIEdgeInsets(top: self.subLyricTableView.frame.size.height * 0.5, left: 0, bottom: self.subLyricTableView.frame.size.height * 0.5, right: 0);

        
        
        self.tableView = UITableView.init(frame: CGRect.init(x: SCREEN_WIDTH, y: 10, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-184))
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tag = TableViewType.lyricTable.rawValue
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        scrollView.addSubview(self.tableView)
        //是歌词起始都在中间位置
        self.tableView.contentInset = UIEdgeInsets(top: self.tableView.frame.size.height * 0.5, left: 0, bottom: self.tableView.frame.size.height * 0.5, right: 0);
        
        
        self.noLyricLB1 = UILabel.init(frame: CGRect.init(x: 0, y: SCREEN_WIDTH, width: SCREEN_WIDTH, height: 50))
        self.noLyricLB1.text = "暂无歌词"
        self.noLyricLB1.textAlignment = NSTextAlignment.center
        self.noLyricLB1.isHidden = true
        scrollView.addSubview(self.noLyricLB1)
        
        self.noLyricLB2 = UILabel.init(frame: CGRect.init(x: SCREEN_WIDTH, y: (SCREEN_HEIGHT-214)*0.5, width: SCREEN_WIDTH, height: 50))
        self.noLyricLB2.text = "暂无歌词"
        self.noLyricLB2.textAlignment = NSTextAlignment.center
        self.noLyricLB2.isHidden = true
        scrollView.addSubview(self.noLyricLB2)
    }
    
    //显示播放列表
    @objc func showMusicList()  {
        self.rightView = UIView.init(frame: self.view.bounds)
        self.rightView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        self.navigationController?.view.addSubview(self.rightView)
        self.rightView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(rightViewRemoved))
        tap.delegate = self;
        self.rightView.addGestureRecognizer(tap)

        let bgView = UIImageView.init(frame: CGRect.init(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT*0.7))
        bgView.image = UIImage.init(named: "QQListBack");
        bgView.tag = 200
        bgView.isUserInteractionEnabled = true
        self.rightView.addSubview(bgView)
        
        let musicListView = UITableView.init(frame: bgView.bounds, style: UITableView.Style.plain)
        musicListView.delegate = self
        musicListView.dataSource = self
        musicListView.backgroundColor = UIColor.clear
        musicListView.tag = TableViewType.musicTable.rawValue
        musicListView.separatorStyle = UITableViewCell.SeparatorStyle.none
        let manager = MZMusicPlayerManager.shareManager
        musicListView.selectRow(at: IndexPath.init(row: manager.playIndex, section: 0), animated: false, scrollPosition: UITableView.ScrollPosition.top)
        bgView.addSubview(musicListView)
        
        UIView.animate(withDuration: 0.5) {
            bgView.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT*0.3, width: SCREEN_WIDTH, height: SCREEN_HEIGHT*0.7)
        }
    }
    
    
    @objc func updateAlbumAnimation() {
        self.albumImageView.layer.removeAllAnimations()
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.toValue = 2.0*Double.pi
        rotationAnimation.duration = 5
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = Float.greatestFiniteMagnitude;
        self.albumImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    @objc func rightViewRemoved() {
        let bgView = self.rightView.viewWithTag(200)
        UIView.animate(withDuration: 0.3, animations: {
            bgView?.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT*0.7)
            }) { (true) in
                self.rightView.removeFromSuperview()
                self.rightView = nil
        }
    }
    
    @objc func dissmissVC()  {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == TableViewType.lyricTable.rawValue || tableView.tag == TableViewType.subLyricTable.rawValue{
            if self.musicItem.musicLyricLyrics != nil {
                return self.musicItem.musicLyricTimes!.count
            } else {
                return 0
            }
        } else {
            let manager = MZMusicPlayerManager.shareManager
            return manager.playerItemList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == TableViewType.lyricTable.rawValue {
            var cell:MusicLyricCell! = tableView.dequeueReusableCell(withIdentifier: "lyric") as? MusicLyricCell
            if cell==nil {
                cell = MusicLyricCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "lyric")
            }
            cell.titleLB.text = self.musicItem.musicLyricLyrics?.object(at: indexPath.row) as? String
            let maxSize = CGSize.init(width: SCREEN_WIDTH-40, height: CGFloat(Float.greatestFiniteMagnitude))
            let size = cell.titleLB.sizeThatFits(maxSize)
            if size.height>20 {
                cell.titleLB.frame = CGRect.init(x: 20, y: 10, width: SCREEN_WIDTH-40, height: size.height)
                cell.height = 20+size.height
            }
            return cell!
        } else if tableView.tag == TableViewType.subLyricTable.rawValue{
            var cell:MusicLyricCell! = tableView.dequeueReusableCell(withIdentifier: "subLyric") as? MusicLyricCell
            if cell==nil {
                cell = MusicLyricCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "subLyric")
            }
            cell.titleLB.text = self.musicItem.musicLyricLyrics?.object(at: indexPath.row) as? String
            let maxSize = CGSize.init(width: SCREEN_WIDTH-40, height: CGFloat(Float.greatestFiniteMagnitude))
            let size = cell.titleLB.sizeThatFits(maxSize)
            if size.height>20 {
                cell.titleLB.frame = CGRect.init(x: 20, y: 10, width: SCREEN_WIDTH-40, height: size.height)
                cell.height = 20+size.height
            }
            return cell!
        } else {
            var cell:MusicSubListCell! = tableView.dequeueReusableCell(withIdentifier: "music") as? MusicSubListCell
            if cell == nil {
                cell = MusicSubListCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "music")
            }
            let manager = MZMusicPlayerManager.shareManager
            let item:MusicItem = manager.playerItemList.object(at: indexPath.row) as! MusicItem
            cell.musicItem = item
            return cell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == TableViewType.musicTable.rawValue {
             let manager = MZMusicPlayerManager.shareManager
            manager.playMusic(playList: manager.playerItemList, playIndex: indexPath.row)
            self.rightViewRemoved()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == TableViewType.lyricTable.rawValue {
            let cell:MusicLyricCell = self.tableView(tableView, cellForRowAt: indexPath) as! MusicLyricCell
            return cell.height
        }else if tableView.tag == TableViewType.subLyricTable.rawValue{
            let cell:MusicLyricCell = self.tableView(tableView, cellForRowAt: indexPath) as! MusicLyricCell
            return cell.height
        } else {
            return 50
        }
    }
    
    //tap点击事件和tableview冲突
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if(NSStringFromClass((touch.view?.classForCoder)!) == "UITableViewCellContentView") {
            return false
        }
        return true
    }
    
    
    @objc func changeMusicPlayMode(sender:UIButton) {
        let manager = MZMusicPlayerManager.shareManager
        if sender.isSelected {
            manager.setupPlayMode(isCircle: true)
        } else {
            manager.setupPlayMode(isCircle: false)
        }
        sender.isSelected = !sender.isSelected
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
    
    
    @objc func updateMusicProgress(slider:UISlider) {
        let manager = MZMusicPlayerManager.shareManager
        let duration:Float = Float(manager.durationTime)!
        manager.updateMusicWithCurrentTime(currentTime: duration*slider.value)
    }

    func playMusic(musicItem: MusicItem) {
        self.noLyricLB1.isHidden = true
        self.noLyricLB2.isHidden = true
        
        self.titleLB.setBackgroundColr(backgroundColr: UIColor.clear, text: musicItem.title, font: UIFont.systemFont(ofSize: 20), textColor: UIColor.white,textAlignment:NSTextAlignment.center)
        
        let imgData = MusicDatabaseManager.share.queryLargeAlbumImage(songid: musicItem.mid)
        if imgData != nil {
            self.albumImageView.image = UIImage.init(data: imgData!)
            self.bgView.image = UIImage.init(data: imgData!)
        } else {
            self.albumImageView.sd_setImage(with: URL.init(string: musicItem.getAblumUrl()), placeholderImage: UIImage.init(named: "QQListBack"))
            self.bgView.sd_setImage(with: URL.init(string: musicItem.getAblumUrl()), placeholderImage: UIImage.init(named: "QQListBack"))
        }
        
        self.authorLB.text = musicItem.getSingerName()
        self.musicItem = musicItem
        self.tableView.reloadData()
        self.subLyricTableView.reloadData()
        
        if self.rightView != nil{
            let musicListView:UITableView! = self.rightView.viewWithTag(TableViewType.musicTable.rawValue) as? UITableView
        let manager = MZMusicPlayerManager.shareManager
            musicListView.selectRow(at: IndexPath.init(row: manager.playIndex, section: 0), animated: false, scrollPosition: UITableView.ScrollPosition.top)
        }
    }
    
    func lyricUpdate(index: NSInteger) {
        let manager = MZMusicPlayerManager.shareManager
        if manager.musicPlayer.rate == 0 {
            self.updateWithMusicPause()
        } else {
            self.updateWithMusicPlay()
        }
        
        self.progressView.value = Float(manager.currentTime)!/Float(manager.durationTime)!
        self.currentTimeLB.text = manager.currentTimeStr
        self.durationLB.text = manager.durationStr
    
        if index < 0 {
            self.noLyricLB1.isHidden = false
            self.noLyricLB2.isHidden = false
            return
        }
        
        if index == 0 {
            self.musicItem = manager.musicItem
            self.tableView.reloadData()
            self.subLyricTableView.reloadData()
        }

        self.noLyricLB1.isHidden = true
        self.noLyricLB2.isHidden = true
        if self.musicItem.musicLyricLyrics != nil {
            self.tableView.selectRow(at: IndexPath.init(row: index, section: 0), animated: (manager.musicPlayer.rate > 0), scrollPosition: UITableView.ScrollPosition.middle)
            self.subLyricTableView.selectRow(at: IndexPath.init(row: index, section: 0), animated: (manager.musicPlayer.rate > 0), scrollPosition: UITableView.ScrollPosition.middle)
        }
    }
    
    func updateWithMusicPause() {
        self.playBtn.isSelected = false
    }

    func updateWithMusicPlay() {
        self.playBtn.isSelected = true
    }
    
    func loadProgress(progress: Float) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
