//
//  MusicSongListVC.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/14.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit

class MusicSongListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView:UITableView!
    var songListItem:SongListItem!
    var model:SongListDetail!
    var logoView:UIImageView!
    var creatorIconView:UIImageView!
    var creatorNameLB:UILabel!
    var songnumLB:UILabel!
    var visitnumLB:UILabel!
    var descLB:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "歌单";
        self.view.backgroundColor = .white;
        
        NotificationCenter.default.addObserver(self, selector: #selector(skipMusic), name: Notification.Name.init(rawValue: "SkipMusic"), object: nil);
        
        let bgView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT/2));
        bgView.contentMode = .scaleAspectFill;
        bgView.clipsToBounds = true;
        bgView.sd_setImage(with: URL.init(string: self.songListItem.imgurl), completed: nil);
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
        let footer = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        tableView.tableFooterView = footer;
        
        MZMusicAPIRequest.getSongListDetail(id: self.songListItem!.dissid) { (detail) in
            if detail != nil {
                bgView.isHidden = false;
                self.logoView.isHidden = false;
                self.model = detail;
                self.tableView.reloadData();
                self.creatorIconView.sd_setImage(with: URL.init(string: self.model.headurl), completed: nil);
                self.creatorNameLB.text = self.model.nick;
                self.songnumLB.text = "歌曲数量："+String(self.model.songnum);
                self.visitnumLB.text = "收听数："+String(self.model.visitnum);
                if (self.model.visitnum >= 10000) {
                    self.visitnumLB.text = String(format: "收听数：%.1f万", CGFloat(self.model.visitnum)/10000.0);
                }
                if (self.model.visitnum >= 100000000) {
                    self.visitnumLB.text = String(format: "收听数：%.1f亿", CGFloat(self.model.visitnum)/100000000.0);
                }
                self.descLB.text = "简介："+self.model.desc.htmlText();
                self.skipMusic();
            }
        }
    }
    
    func initHeaderView() {
        let SCALE = SCREEN_WIDTH/375;
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 160*SCALE));
        headerView.backgroundColor = .clear;
        headerView.isUserInteractionEnabled = true;
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(songListIntroduce));
        headerView.addGestureRecognizer(tap);
        
        let iconView = UIImageView.init(frame: CGRect.init(x: 30*SCALE, y: 20*SCALE, width: 120*SCALE, height: 120*SCALE));
        iconView.layer.cornerRadius = 5*SCALE;
        iconView.layer.masksToBounds = true;
        iconView.sd_setImage(with: URL.init(string: self.songListItem.imgurl), completed: nil);
        iconView.isHidden = true;
        headerView.addSubview(iconView);
        self.logoView = iconView;
        
        let nameLB = UILabel.init(frame: CGRect.init(x: 170*SCALE, y: 20*SCALE, width: SCREEN_WIDTH-190*SCALE, height: 20*SCALE));
        nameLB.text = self.songListItem.dissname;
        nameLB.numberOfLines = 2;
        nameLB.textColor  = .white;
        nameLB.font = .systemFont(ofSize: 16*SCALE);
        let maxSize = CGSize.init(width: SCREEN_WIDTH-190*SCALE, height: CGFloat(Float.greatestFiniteMagnitude));
        let size = nameLB.sizeThatFits(maxSize);
        nameLB.frame = CGRect.init(x: 170*SCALE, y: 20*SCALE, width: SCREEN_WIDTH-190*SCALE, height: size.height);
        headerView.addSubview(nameLB);
        
        let creatorIconView = UIImageView.init(frame: CGRect.init(x: 170*SCALE, y: 60*SCALE, width: 16*SCALE, height: 16*SCALE));
        creatorIconView.layer.cornerRadius = 8*SCALE;
        creatorIconView.layer.masksToBounds = true;
        headerView.addSubview(creatorIconView);
        self.creatorIconView = creatorIconView;
        
        let creatorNameLB = UILabel.init(frame: CGRect.init(x: 190*SCALE, y: 60*SCALE, width: SCREEN_WIDTH-210*SCALE, height: 16*SCALE));
        creatorNameLB.textColor = .white;
        creatorNameLB.font = .systemFont(ofSize: 12*SCALE);
        headerView.addSubview(creatorNameLB);
        self.creatorNameLB = creatorNameLB;
        
        let songnumLB = UILabel.init(frame: CGRect.init(x: 170*SCALE, y: 80*SCALE, width: SCREEN_WIDTH-190*SCALE, height: 16*SCALE));
        songnumLB.textColor = .white;
        songnumLB.font = .systemFont(ofSize: 12*SCALE);
        headerView.addSubview(songnumLB);
        self.songnumLB = songnumLB;
        
        let visitnumLB = UILabel.init(frame: CGRect.init(x: 170*SCALE, y: 100*SCALE, width: SCREEN_WIDTH-190*SCALE, height: 16*SCALE));
        visitnumLB.textColor = .white;
        visitnumLB.font = .systemFont(ofSize: 12*SCALE);
        headerView.addSubview(visitnumLB);
        self.visitnumLB = visitnumLB;
        
        let descLB = UILabel.init(frame: CGRect.init(x: 170*SCALE, y: 120*SCALE, width: SCREEN_WIDTH-190*SCALE, height: 20*SCALE));
        descLB.textColor = .white;
        descLB.font = .systemFont(ofSize: 12*SCALE);
        headerView.addSubview(descLB);
        self.descLB = descLB;
        
        self.tableView.tableHeaderView = headerView;
    }
    
    @objc func songListIntroduce() -> Void {
        let vc = MusicSongListIntroduceVC.init();
        vc.model = self.model;
        vc.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model != nil ?self.model.songlist.count:0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicListCell") as! MusicListCell;
        cell.musicItem = self.model.songlist[indexPath.row];
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
        MZMusicPlayerManager.shareManager.playMusic(playList: self.model!.songlist! as NSArray, playIndex: indexPath.row);
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    
    @objc func skipMusic() -> Void {
        let manager = MZMusicPlayerManager.shareManager
        let musicItem = manager.musicItem
        for i in 0..<self.model.songlist.count {
            let item:MusicItem = self.model.songlist[i] 
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
