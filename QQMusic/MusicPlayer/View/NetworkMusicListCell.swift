//
//  NetworkMusicListCell.swift
//  MyFirstSwiftProject
//
//  Created by 曾龙 on 17/4/1.
//  Copyright © 2017年 scinan. All rights reserved.
//

import UIKit
import MBProgressHUD
import SDWebImage

class NetworkMusicListCell: UITableViewCell {

    var musicItem:MusicItem!{
        didSet{
            self.titleLB.text = musicItem.songname
            self.authorLB.text = musicItem.singername
            self.loveBtn.isSelected = MusicDatabaseManager.share.queryLoveMusic(musicItem: musicItem)
            self.downloadBtn.isSelected = MusicDatabaseManager.share.queryMusicDownload(musicItem: musicItem)
        }
    }
    var titleLB:UILabel!
    var authorLB:UILabel!
    var loveBtn:UIButton!
    var downloadBtn:UIButton!
    var loveCallback:(()->Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCell.SelectionStyle.none;
        self.setUpUI();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpUI() {
        
        self.backgroundColor = UIColor.clear
        
        let bgView = UIView.init(frame: CGRect.init(x: 10, y: 5, width: SCREEN_WIDTH-20, height: 55))
        bgView.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        bgView.layer.cornerRadius = 5
        bgView.layer.masksToBounds = true
        self.addSubview(bgView)
    
        self.titleLB = UILabel.init(frame: CGRect.init(x: 20, y: 5, width: 260, height: 20))
        self.titleLB.backgroundColor = UIColor.clear
        self.titleLB.textColor = UIColor.black
        self.titleLB.textAlignment = NSTextAlignment.left
        self.titleLB.font = UIFont.systemFont(ofSize: 15)
        bgView.addSubview(self.titleLB)
        
        self.authorLB = UILabel.init(frame: CGRect.init(x: 20, y: 30, width: 160, height: 20))
        self.authorLB.backgroundColor = UIColor.clear
        self.authorLB.textColor = UIColor.gray
        self.authorLB.textAlignment = NSTextAlignment.left
        self.authorLB.font = UIFont.systemFont(ofSize: 15)
        bgView.addSubview(self.authorLB)
        
        
        self.loveBtn = UIButton.init(type: UIButton.ButtonType.custom)
        self.loveBtn.frame = CGRect.init(x: SCREEN_WIDTH-90, y: 30, width: 30, height: 30)
        self.loveBtn.setBackgroundImage(UIImage.init(named: "love_btn_normal"), for: UIControl.State.normal)
        self.loveBtn.setBackgroundImage(UIImage.init(named: "love_btn_select"), for: UIControl.State.selected)
        self.loveBtn.addTarget(self, action: #selector(loveMusic(sender:)), for: UIControl.Event.touchUpInside)
        self.addSubview(self.loveBtn)
        
        self.downloadBtn = UIButton.init(type: UIButton.ButtonType.custom)
        self.downloadBtn.frame = CGRect.init(x: SCREEN_WIDTH-50, y: 30, width: 30, height: 30)
        self.downloadBtn.setBackgroundImage(UIImage.init(named: "icon_download"), for: UIControl.State.normal)
        self.downloadBtn.setBackgroundImage(UIImage.init(named: "icon_download_enable"), for: UIControl.State.selected)
        self.downloadBtn.addTarget(self, action: #selector(downloadMusic(sender:)), for: UIControl.Event.touchUpInside)
        self.addSubview(self.downloadBtn)
    }
    
    @objc func loveMusic(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        let databaseManager = MusicDatabaseManager.share
        databaseManager.insertLoveMusic(musicItem: self.musicItem)
        if self.loveCallback != nil {
            self.loveCallback!()
        }
    }
    
    @objc func downloadMusic(sender:UIButton) {
        if sender.isSelected {
            MBProgressHUD.showError(error: "该歌曲已下载过")
        } else {
            sender.isSelected = !sender.isSelected
            //下载歌曲
            MZDownloadManager.sharedInstance.newTask(url: self.musicItem.url!)
            MusicDatabaseManager.share.insertDownloadMusic(musicItem: self.musicItem)

            //下载歌词
            MZMusicAPIRequest.getMusicLyric(musicID: self.musicItem.songid, callback: { (lyric) in
                MusicDatabaseManager.share.insertMusicLyric(songid: self.musicItem.songid, lyric: lyric)
            })
            //下载大图片
            SDWebImageDownloader.shared.downloadImage(with: URL.init(string: self.musicItem.albumpic_big), options: SDWebImageDownloaderOptions.continueInBackground, progress: { (receivedSize, expectedSize, url) in
                
                }, completed: { (image, imgData, error, finished) in
                    if imgData != nil {
                        MusicDatabaseManager.share.insertLargeAlbumImageData(songid: self.musicItem.songid, imgData: imgData!)
                        //下载小图片
                        SDWebImageDownloader.shared.downloadImage(with: URL.init(string: self.musicItem.albumpic_small!), options: SDWebImageDownloaderOptions.continueInBackground, progress: { (receivedSize, expectedSize, url) in
                            
                            }, completed: { (image, imgData, error, finished) in
                                if imgData != nil {
                                    MusicDatabaseManager.share.insertSmallAlbumImageData(songid: self.musicItem.songid, imgData: imgData!)
                                }
                        })
                    }
            })
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if self.isSelected {
            self.titleLB.textColor = MainColor
            self.authorLB.textColor = MainColor
        } else {
            self.titleLB.textColor = UIColor.black
            self.authorLB.textColor = UIColor.gray
        }
    }
}
