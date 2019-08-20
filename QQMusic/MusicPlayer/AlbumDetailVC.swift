//
//  AlbumDetailVC.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/20.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit

class AlbumDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var albumId:String!
    var albumDetail:AlbumDetail!
    var musicList:[MusicItem]!
    var bgView:UIImageView!
    var tableView:UITableView!
    var logoView:UIImageView!
    var nameLB:UILabel!
    var singerNameLB:UILabel!
    var descLB:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white;
        self.title = "专辑"
        
        NotificationCenter.default.addObserver(self, selector: #selector(skipMusic), name: Notification.Name.init(rawValue: "SkipMusic"), object: nil);
        
        bgView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT/2));
        bgView.contentMode = .scaleAspectFill;
        bgView.clipsToBounds = true;
        bgView.isHidden = true;
        self.view.addSubview(bgView);
        
        //创建背景毛玻璃效果
        let blurEffect  = UIBlurEffect.init(style: UIBlurEffect.Style.light)
        let blurView = UIVisualEffectView.init(effect: blurEffect)
        blurView.frame.size = CGSize.init(width: SCREEN_WIDTH, height: SCREEN_HEIGHT/2)
        let vibrancyView = UIVisualEffectView.init(effect: UIVibrancyEffect.init(blurEffect: blurEffect))
        vibrancyView.frame.size = CGSize.init(width: SCREEN_WIDTH, height: SCREEN_HEIGHT/2)
        blurView.contentView.addSubview(vibrancyView)
        self.view.addSubview(blurView)
        
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: Navi_Height, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-Navi_Height-Tabbar_Height), style: .plain);
        tableView.backgroundColor = .clear;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = .none;
        tableView.showsVerticalScrollIndicator = false;
        tableView.register(MusicListCell.classForCoder(), forCellReuseIdentifier: "MusicListCell")
        self.view.addSubview(tableView);
        self.tableView = tableView;
        self.initHeaderView();
        
        MZMusicAPIRequest.getAlbumDetail(id: self.albumId) { (detail) in
            if detail != nil {
                self.albumDetail = detail;
                self.musicList = MusicItem.convertSongListToMusicList(songList: self.albumDetail!.getSongInfo)
                self.bgView.sd_setImage(with: URL.init(string: self.albumDetail.getAblumUrl()), completed: nil);
                self.bgView.isHidden = false;
                self.logoView.sd_setImage(with: URL.init(string: self.albumDetail.getAblumUrl()), completed: nil);
                self.logoView.isHidden = false;
                self.tableView.reloadData();
                self.nameLB.text = self.albumDetail.getAlbumInfo.Falbum_name;
                let SCALE = SCREEN_WIDTH/375;
                let maxSize = CGSize.init(width: SCREEN_WIDTH-170*SCALE, height: CGFloat(Float.greatestFiniteMagnitude));
                let size = self.nameLB.sizeThatFits(maxSize);
                self.nameLB.frame = CGRect.init(x: 150*SCALE, y: 20*SCALE, width: SCREEN_WIDTH-170*SCALE, height: size.height);
                self.singerNameLB.text = self.albumDetail.getSingerInfo.Fsinger_name;
                self.descLB.text = "简介："+self.albumDetail.getAlbumDesc.Falbum_desc.htmlText();
                self.skipMusic();
            }
        }
    }
    
    func initHeaderView() {
        let SCALE = SCREEN_WIDTH/375;
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 140*SCALE));
        headerView.backgroundColor = .clear;
        headerView.isUserInteractionEnabled = true;
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(songListIntroduce));
        headerView.addGestureRecognizer(tap);
        
        let iconView = UIImageView.init(frame: CGRect.init(x: 30*SCALE, y: 20*SCALE, width: 100*SCALE, height: 100*SCALE));
        iconView.layer.cornerRadius = 5*SCALE;
        iconView.layer.masksToBounds = true;
        iconView.isHidden = true;
        headerView.addSubview(iconView);
        self.logoView = iconView;
        
        let nameLB = UILabel.init(frame: CGRect.init(x: 150*SCALE, y: 20*SCALE, width: SCREEN_WIDTH-170*SCALE, height: 20*SCALE));
        nameLB.numberOfLines = 3;
        nameLB.textColor  = .white;
        nameLB.font = .systemFont(ofSize: 16*SCALE);
        headerView.addSubview(nameLB);
        self.nameLB = nameLB;
        
        let creatorNameLB = UILabel.init(frame: CGRect.init(x: 150*SCALE, y: 80*SCALE, width: SCREEN_WIDTH-170*SCALE, height: 16*SCALE));
        creatorNameLB.textColor = .white;
        creatorNameLB.font = .systemFont(ofSize: 12*SCALE);
        headerView.addSubview(creatorNameLB);
        self.singerNameLB = creatorNameLB;
        
        let descLB = UILabel.init(frame: CGRect.init(x: 150*SCALE, y: 100*SCALE, width: SCREEN_WIDTH-170*SCALE, height: 20*SCALE));
        descLB.textColor = .white;
        descLB.font = .systemFont(ofSize: 12*SCALE);
        headerView.addSubview(descLB);
        self.descLB = descLB;
        
        self.tableView.tableHeaderView = headerView;
    }
    
    @objc func songListIntroduce() -> Void {
        let albumIntroduceVC = AlbumDetailIntroduceVC.init();
        albumIntroduceVC.albumDetail = self.albumDetail;
        self.navigationController?.pushViewController(albumIntroduceVC, animated: true);
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musicList != nil ?self.musicList.count:0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicListCell") as! MusicListCell;
        cell.musicItem = self.musicList[indexPath.row];
        cell.index = indexPath.row;
        cell.playMVCallback = { vid in
            let vc = MusicMVDetailVC.init();
            vc.vid = vid
            vc.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(vc, animated: true);
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MZMusicPlayerManager.shareManager.playMusic(playList: self.musicList as NSArray, playIndex: indexPath.row);
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    
    @objc func skipMusic() -> Void {
        let manager = MZMusicPlayerManager.shareManager
        let musicItem = manager.musicItem
        for i in 0..<self.musicList.count {
            let item:MusicItem = self.musicList[i]
            if item.mid == musicItem?.mid {
                self.tableView.selectRow(at: IndexPath.init(row: i, section: 0), animated: false, scrollPosition: UITableView.ScrollPosition.none)
                return
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }

}
