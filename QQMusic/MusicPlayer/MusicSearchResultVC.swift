//
//  MusicSearchResultVC.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/22.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit
import MJRefresh
import MBProgressHUD

class MusicSearchResultVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.currentKeyword = searchController.searchBar.text;
    }
    

    var tableView:UITableView!
    var list = [Any]()
    var type = "song"
    var page = 1
    var header:UIView!
    var selectedBtn:UIButton!
    var animationView:UIView!
    
    var currentKeyword:String!
    
    var originY:CGFloat! {
        didSet {
            header.frame = CGRect.init(x: 0, y:originY, width: SCREEN_WIDTH, height: 40)
            tableView.frame = CGRect.init(x: 0, y: header.frame.maxY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-Tabbar_Height-header.frame.maxY)
        }
    }
    var keyword:String! {
        didSet {
            self.loadNew()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white;
        
        header = UIView.init(frame: CGRect.init(x: 0, y:Navi_Height, width: SCREEN_WIDTH, height: 40));
        let scrollView = UIView.init(frame: header.bounds);
        let types = ["歌曲","MV","专辑","歌单","歌手","歌词"]
        for (index,item) in types.enumerated() {
            let btn = UIButton.init(type: .custom);
            btn.frame = CGRect.init(x: SCREEN_WIDTH/6*CGFloat(index), y: 0, width: SCREEN_WIDTH/6, height: 40);
            btn.setTitle(item, for: .normal);
            btn.setTitleColor(RGB(r: 136, g: 136, b: 136), for: .normal);
            btn.setTitleColor(MainColor, for: .selected);
            btn.titleLabel?.font = .systemFont(ofSize: 12);
            btn.tag = 100+index;
            btn.addTarget(self, action: #selector(selectType), for: .touchUpInside);
            if index == 0 {
                btn.isSelected = true;
                self.selectedBtn = btn;
            }
            scrollView.addSubview(btn);
        }
        header.addSubview(scrollView);
        animationView = UIView.init(frame: CGRect.init(x: (SCREEN_WIDTH/6-20)/2, y: 38, width: 20, height: 2))
        animationView.backgroundColor = MainColor;
        header.addSubview(animationView);
        self.view.addSubview(header);

        tableView = UITableView.init(frame: CGRect.init(x: 0, y: header.frame.maxY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-Tabbar_Height-header.frame.maxY), style:.plain);
        tableView.backgroundColor = .white
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = .none;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.register(MusicListCell.classForCoder(), forCellReuseIdentifier: "MusicListCell")
        tableView.register(MusicSearchMVCell.classForCoder(), forCellReuseIdentifier: "MusicSearchMVCell")
        tableView.register(MusicSearchAlbumCell.classForCoder(), forCellReuseIdentifier: "MusicSearchAlbumCell")
        tableView.register(MusicSearchLrcCell.classForCoder(), forCellReuseIdentifier: "MusicSearchLrcCell")
        self.view.addSubview(tableView);
        
        tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 10));
    }
    
    @objc func selectType(sender:UIButton) -> Void {
        if sender == self.selectedBtn {
            return;
        }
        
        UIApplication.shared.keyWindow?.endEditing(true)
        if self.currentKeyword != nil && self.currentKeyword.count > 0 {
            self.keyword = self.currentKeyword;
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            let frame = CGRect.init(x: (SCREEN_WIDTH/6)*CGFloat(sender.tag-100)+(SCREEN_WIDTH/6-20)/2, y: 38, width: 20, height: 2);
            self.animationView.frame = frame;
        }, completion: {_ in
            self.selectedBtn.isSelected = false;
            self.selectedBtn = sender;
            self.selectedBtn.isSelected = true;
            let types = ["song","mv","album","songList","singer","lrc"]
            self.type = types[sender.tag-100]
            if self.keyword == nil || self.keyword.count == 0 {
                return
            }
            self.loadNew()
        })
    }
    
    func loadNew() -> Void {
        if self.type == "songList" {
            self.page = 0;
        } else {
            self.page = 1;
        }
        self.loadData()
    }
    
    @objc func loadMore() -> Void {
        self.page += 1;
        self.loadData()
    }
    
    func loadData() -> Void {
        MZMusicAPIRequest.searchMusicList(keyword: keyword, type: type, pageSize: 20, page: page, format: 0) { (array) in
            if self.type == "songList" {
                if self.page == 0 {
                    self.list.removeAll();
                }
            } else {
                if self.page == 1 {
                    self.list.removeAll();
                }
            }
            self.list.append(contentsOf: array);
            self.tableView.reloadData();
            if self.tableView.mj_footer != nil {
                if self.tableView.mj_footer.isRefreshing {
                    self.tableView.mj_footer.endRefreshing();
                }
            } else {
                self.tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.loadMore));
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.type == "song" || self.type == "singer" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MusicListCell") as! MusicListCell
            cell.musicItem = self.list[indexPath.row] as? MusicItem;
            cell.index = indexPath.row;
            return cell;
        } else if self.type == "mv" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MusicSearchMVCell") as! MusicSearchMVCell
            cell.mvItem = self.list[indexPath.row] as? SearchMVItem
            return cell;
        } else if self.type == "album" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MusicSearchAlbumCell") as! MusicSearchAlbumCell
            cell.albumItem = self.list[indexPath.row] as? SearchAlbumItem;
            return cell;
        } else if self.type == "songList" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MusicSearchAlbumCell") as! MusicSearchAlbumCell
            cell.songListItem = self.list[indexPath.row] as? SongListItem;
            return cell;
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MusicSearchLrcCell") as! MusicSearchLrcCell
            cell.lrcItem = self.list[indexPath.row] as? SearchLrcItem
            cell.unfoldBlock = {
                self.tableView.reloadData()
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.type == "song" || self.type == "singer" {
            return 65;
        } else if self.type == "mv" {
            return 82;
        } else if self.type == "album" || self.type == "songList" {
            return 70;
        } else {
            let lrcItem = self.list[indexPath.row] as! SearchLrcItem
            if lrcItem.unFold {
                return lrcItem.getUnFoldHeight() + 115;
            } else {
                return lrcItem.getFoldHeight() + 115;
            }
        }
    }

}
