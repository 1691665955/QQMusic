//
//  MusicMVListVC.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/17.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit
import MJRefresh

class MusicMVListVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var tableView:UITableView!
    var mvList=[MVItem]()
    var page:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "热门MV";
        
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: Navi_Height, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-Navi_Height-Tabbar_Height), style: .plain);
        tableView.separatorStyle = .none;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.register(MusicMVListCell.classForCoder(), forCellReuseIdentifier: "MusicMVListCell");
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMore))
        self.view.addSubview(tableView);
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 10));
        tableView.tableHeaderView = headerView;
        
        self.loadNew();
    }
    
    func loadNew() -> Void {
        page = 0;
        self.loadData();
    }
    
    @objc func loadMore() -> Void {
        page += 1;
        self.loadData();
    }
    
    func loadData() -> Void {
        MZMusicAPIRequest.getHotMVList(order: 1, pageSize: 20, page: page) { (list) in
            self.tableView.mj_footer.endRefreshing();
            self.mvList.append(contentsOf: list);
            self.tableView.reloadData();
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mvList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicMVListCell") as! MusicMVListCell;
        cell.mvItem = self.mvList[indexPath.row];
        cell.index = indexPath.row;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MusicMVDetailVC.init();
        vc.vid = self.mvList[indexPath.row].vid;
        vc.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc, animated: true);
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (SCREEN_WIDTH-20)/640*360+10;
    }
}
