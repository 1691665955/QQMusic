//
//  MusicRankingListVC.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/16.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit
import MJRefresh

class MusicRankingListVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var rankingTitle:String!
    var rankingID:Int!
    var musicList=[MusicItem]()
    var tableView:UITableView!
    var page:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white;
        self.title = rankingTitle;
        
        NotificationCenter.default.addObserver(self, selector: #selector(skipMusic), name: Notification.Name.init(rawValue: "SkipMusic"), object: nil);
        
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: Navi_Height, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-Navi_Height-Tabbar_Height), style: .plain);
        tableView.backgroundColor = .clear;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = .none;
        tableView.showsVerticalScrollIndicator = false;
        tableView.register(MusicListCell.classForCoder(), forCellReuseIdentifier: "MusicListCell")
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMore))
        self.view.addSubview(tableView);
        
        let footer = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        tableView.tableFooterView = footer;
        
        self.loadNew();
    }
    
    func loadNew() -> Void {
        self.page = 0;
        self.loadData();
    }
    
    @objc func loadMore() -> Void {
        self.page += 1;
        self.loadData();
    }
    
    func loadData() -> Void {
        MZMusicAPIRequest.getHotMusicList(id: rankingID, pageSize: 20, page: page, format: 0) { (list) in
            self.tableView.mj_footer.endRefreshing();
            self.musicList.append(contentsOf: list);
            self.tableView.reloadData();
            self.skipMusic();
            if self.page == 4 {
                self.tableView.mj_footer = nil
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musicList.count;
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
