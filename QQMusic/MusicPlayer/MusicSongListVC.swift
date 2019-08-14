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
    var musicList:[MusicItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "歌单";
        self.view.backgroundColor = .white;
        
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: Navi_Height, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-Navi_Height-Tabbar_Height), style: .plain);
        tableView.dataSource = self;
        tableView.delegate = self;
        self.view.addSubview(tableView);
        self.tableView = tableView;
        self.initHeaderView();
        
        MZMusicAPIRequest.getSongListDetail(id: self.songListItem!.dissid) { (musicList:[MusicItem]) in
            
        }
    }
    
    func initHeaderView() {
        let SCALE = SCREEN_WIDTH/375;
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 180*SCALE));
        let bgView = UIImageView.init(frame: headerView.bounds);
        bgView.contentMode = .scaleAspectFill;
        bgView.clipsToBounds = true;
        bgView.sd_setImage(with: URL.init(string: self.songListItem.imgurl), completed: nil);
        headerView.addSubview(bgView);
        
        //创建背景毛玻璃效果
        let blurEffect  = UIBlurEffect.init(style: UIBlurEffect.Style.light)
        let blurView = UIVisualEffectView.init(effect: blurEffect)
        blurView.frame.size = CGSize.init(width: SCREEN_WIDTH, height: 180*SCALE)
        let vibrancyView = UIVisualEffectView.init(effect: UIVibrancyEffect.init(blurEffect: blurEffect))
        vibrancyView.frame.size = CGSize.init(width: SCREEN_WIDTH, height: 180*SCALE)
        blurView.contentView.addSubview(vibrancyView)
        headerView.addSubview(blurView)
        
        let iconView = UIImageView.init(frame: CGRect.init(x: 30*SCALE, y: 20*SCALE, width: 120*SCALE, height: 120*SCALE));
        iconView.sd_setImage(with: URL.init(string: self.songListItem.imgurl), completed: nil);
        headerView.addSubview(iconView);
        
        
        
        self.tableView.tableHeaderView = headerView;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init();
    }

}
