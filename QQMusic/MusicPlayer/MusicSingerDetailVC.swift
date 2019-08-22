//
//  MusicSingerDetailVC.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/21.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit
import MJRefresh

class MusicSingerDetailVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var tableView:UITableView!
    var avatarView:UIImageView!
    var nameLB:UILabel!
    var fansLB:UILabel!
    var artist:ArtistItem!
    var artistDetail:ArtistDetail!
    var musicList = [MusicItem]()
    var albumList = [ArtistAlbumItem]()
    var mvList = [ArtistMVItem]()
    var page:Int!
    var selectedBtn:UIButton!
    var animationView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white;
        self.title = self.artist.singer_name;
        
        NotificationCenter.default.addObserver(self, selector: #selector(skipMusic), name: Notification.Name.init(rawValue: "SkipMusic"), object: nil);
        
        avatarView = UIImageView.init(frame: CGRect.init(x: 0, y: Navi_Height, width: SCREEN_WIDTH, height: SCREEN_WIDTH-Navi_Height*2));
        avatarView.contentMode = .scaleAspectFill;
        avatarView.clipsToBounds = true;
        avatarView.backgroundColor = RGB(r: 223, g: 223, b: 223);
        avatarView.sd_setImage(with: URL.init(string: self.artist.getLargeSingerPic()), completed: nil);
        avatarView.isHidden = true;
        self.view.addSubview(avatarView);
        
        nameLB = UILabel.init(frame: CGRect.init(x: 0, y: (SCREEN_WIDTH-Navi_Height*2-40)/2, width: SCREEN_WIDTH, height: 40));
        nameLB.textColor = .white;
        nameLB.font = .systemFont(ofSize: 28);
        nameLB.textAlignment = .center;
        nameLB.text = self.artist.singer_name;
        avatarView.addSubview(nameLB);
        
        fansLB = UILabel.init(frame: CGRect.init(x: 0, y: nameLB.frame.maxY+10, width: SCREEN_WIDTH, height: 20));
        fansLB.textColor = .white;
        fansLB.font = .systemFont(ofSize: 12);
        fansLB.textAlignment = .center;
        avatarView.addSubview(fansLB);
        
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: Navi_Height, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-Navi_Height-Tabbar_Height));
        tableView.backgroundColor = .clear;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = .none;
        tableView.register(MusicListCell.classForCoder(), forCellReuseIdentifier: "MusicListCell");
        tableView.register(MusicAlbumListCell.classForCoder(), forCellReuseIdentifier: "MusicAlbumListCell")
        tableView.register(MusicMVListCell.classForCoder(), forCellReuseIdentifier: "MusicMVListCell");
        tableView.register(MusicSingerDescCell.classForCoder(), forCellReuseIdentifier: "MusicSingerDescCell");
        tableView.isHidden = true;
        tableView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil);
        self.view.addSubview(tableView);
        
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH-Navi_Height*2))
        header.backgroundColor = .clear;
        tableView.tableHeaderView = header;
        
        let footer = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 10));
        tableView.tableFooterView = footer;
        
        MZMusicAPIRequest.getArtistDetail(id: self.artist.singer_mid) { (detail) in
            if detail != nil {
                self.artistDetail = detail;
                self.fansLB.text = String.init(format: "粉丝：%ld", (detail?.singer_info.fans)!);
                if (self.artistDetail.singer_info.fans)! >= 10000 {
                    self.fansLB.text = String.init(format: "粉丝：%.1f万", CGFloat(self.artistDetail.singer_info.fans)/10000.0);
                }
                if (self.artistDetail.singer_info.fans)! >= 100000000 {
                    self.fansLB.text = String.init(format: "粉丝：%.1f亿", CGFloat(self.artistDetail.singer_info.fans)/100000000.0);
                }
            }
        }
        self.loadNew();
    }
    
    func loadNew() -> Void {
        self.page = 1;
        self.musicList.removeAll();
        self.albumList.removeAll();
        self.mvList.removeAll();
        if self.selectedBtn == nil || self.selectedBtn.tag%2==0 {
            tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMore))
        } else {
            tableView.mj_footer = nil
        }
        self.loadData();
    }
    
    @objc func loadMore() -> Void {
        self.page += 1;
        self.loadData();
    }
    
    func loadData() -> Void {
        if self.selectedBtn == nil || self.selectedBtn.tag == 100 {
            MZMusicAPIRequest.getArtistMusicList(id: self.artist.singer_mid, pageSize: 20, page: page) { (list) in
                self.avatarView.isHidden = false;
                self.tableView.isHidden = false;
                self.tableView.mj_footer.endRefreshing();
                self.musicList.append(contentsOf: MusicItem.convertArtistMusicListToMusicList(artistMusicList: list));
                self.tableView.reloadData();
                if self.selectedBtn == nil || self.selectedBtn.tag%2==0 {
                    self.skipMusic();
                }
            }
        } else if self.selectedBtn.tag == 101 {
            MZMusicAPIRequest.getArtistAlbumList(id: self.artist.singer_mid) { (list) in
                self.albumList.append(contentsOf: list);
                self.tableView.reloadData();
            }
        } else {
            MZMusicAPIRequest.getArtistMVList(id: self.artist.singer_mid, pageSize: 10, page: page) { (list) in
                self.tableView.mj_footer.endRefreshing();
                self.mvList.append(contentsOf: list);
                self.tableView.reloadData();
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectedBtn == nil || self.selectedBtn.tag == 100 {
            return self.musicList.count;
        } else if self.selectedBtn.tag == 101 {
            return self.albumList.count;
        } else if self.selectedBtn.tag == 102 {
            return self.mvList.count;
        }
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.selectedBtn == nil || self.selectedBtn.tag == 100 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MusicListCell") as! MusicListCell
            cell.musicItem = self.musicList[indexPath.row];
            cell.index = indexPath.row;
            cell.playMVCallback = { vid in
                let vc = MusicMVDetailVC.init();
                vc.vid = vid
                vc.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(vc, animated: true);
            }
            return cell;
        } else if self.selectedBtn.tag == 101 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MusicAlbumListCell") as! MusicAlbumListCell
            cell.albumItem = self.albumList[indexPath.row];
            return cell;
        } else if self.selectedBtn.tag == 102 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MusicMVListCell") as! MusicMVListCell
            cell.artistMVItem = self.mvList[indexPath.row];
            return cell;
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MusicSingerDescCell") as! MusicSingerDescCell
            cell.desc = self.artistDetail.singer_brief;
            return cell;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectedBtn == nil || self.selectedBtn.tag == 100 {
            MZMusicPlayerManager.shareManager.playMusic(playList: self.musicList as NSArray, playIndex: indexPath.row);
        } else if self.selectedBtn.tag == 101 {
            let vc = MusicAlbumDetailVC.init();
            vc.albumId = self.albumList[indexPath.row].album_mid;
            self.navigationController?.pushViewController(vc, animated: true);
        } else if self.selectedBtn.tag == 102 {
            let vc = MusicMVDetailVC.init();
            vc.vid = self.mvList[indexPath.row].vid;
            vc.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(vc, animated: true);
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.selectedBtn == nil || self.selectedBtn.tag == 100 {
            return 65;
        } else if self.selectedBtn.tag == 101 {
            return 70;
        } else if self.selectedBtn.tag == 102 {
            return (SCREEN_WIDTH-20)/640*360+10;
        }
        let cell = self.tableView(tableView, cellForRowAt: indexPath) as! MusicSingerDescCell
        return cell.Height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 40));
        header.backgroundColor = .white;
        
        let titles = ["歌曲","专辑","MV","详情"]
        for i in 0...3 {
            let btn = UIButton.init(type: .custom);
            btn.frame = CGRect.init(x: SCREEN_WIDTH/4*CGFloat(i), y: 0, width: SCREEN_WIDTH/4, height: 40);
            btn.setTitle(titles[i], for: .normal);
            btn.setTitleColor(RGB(r: 136, g: 136, b: 136), for: .normal);
            btn.setTitleColor(MainColor, for: .selected);
            btn.tag = 100+i;
            btn.addTarget(self, action: #selector(selectCategory), for: .touchUpInside);
            header.addSubview(btn);
            if (self.selectedBtn == nil && i == 0) || btn.tag == self.selectedBtn.tag {
                btn.isSelected = true;
                self.selectedBtn = btn;
            }
        }
        
        let lineView = UIView.init(frame: CGRect.init(x: (SCREEN_WIDTH/4-20)/2, y: 38, width: 20, height: 2));
        lineView.backgroundColor = MainColor;
        header.addSubview(lineView);
        if (self.selectedBtn != nil) {
            lineView.frame = CGRect.init(x: (SCREEN_WIDTH/4-20)/2+SCREEN_WIDTH/4*CGFloat(self.selectedBtn.tag-100), y: 38, width: 20, height: 2)
        }
        self.animationView = lineView;
        
        return header;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40;
    }
    
    @objc func selectCategory(sender:UIButton) -> Void {
        if sender == self.selectedBtn {
            return;
        }
    
        UIView.animate(withDuration: 0.2, animations: {
            let frame = CGRect.init(x: (SCREEN_WIDTH/4-20)/2+SCREEN_WIDTH/4*CGFloat(sender.tag-100), y: 38, width: 20, height: 2);
            self.animationView.frame = frame;
        }, completion: {_ in
            self.selectedBtn.isSelected = false;
            self.selectedBtn = sender;
            self.selectedBtn.isSelected = true;
            if sender.tag == 103 {
                self.tableView.mj_footer = nil;
                self.tableView.reloadData();
            } else {
                self.loadNew()
            }
        })
    }

    
    @objc func skipMusic() -> Void {
        if self.selectedBtn == nil || self.selectedBtn.tag == 100 {
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
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let offset = change![NSKeyValueChangeKey.newKey] as! CGPoint
        if offset.y < 0 {
            avatarView.frame = CGRect.init(x: (SCREEN_WIDTH-SCREEN_WIDTH/(SCREEN_WIDTH-Navi_Height*2)*(SCREEN_WIDTH-Navi_Height*2-offset.y))/2, y: Navi_Height, width: SCREEN_WIDTH/(SCREEN_WIDTH-Navi_Height*2)*(SCREEN_WIDTH-Navi_Height*2-offset.y), height: SCREEN_WIDTH-Navi_Height*2-offset.y)
            nameLB.frame = CGRect.init(x: 0, y: (avatarView.frame.size.height-40)/2, width: avatarView.frame.size.width, height: 40);
            fansLB.frame = CGRect.init(x: 0, y: nameLB.frame.maxY+10, width: avatarView.frame.size.width, height: 20);
        } else {
            avatarView.frame = CGRect.init(x: 0, y: Navi_Height, width: SCREEN_WIDTH, height: SCREEN_WIDTH-Navi_Height*2);
            nameLB.frame = CGRect.init(x: 0, y: (SCREEN_WIDTH-Navi_Height*2-40)/2, width: SCREEN_WIDTH, height: 40);
            fansLB.frame = CGRect.init(x: 0, y: nameLB.frame.maxY+10, width: SCREEN_WIDTH, height: 20);
        }
    }
}
