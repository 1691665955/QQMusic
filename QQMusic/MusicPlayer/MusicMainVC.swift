//
//  MusicMainVC.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/4.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit
import MZExtension

class MusicMainVC: UIViewController,MZBannerViewDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate {
    
    var contentView:UIScrollView!
    var homeTableView:UITableView!
    var personTableView:UITableView!
    var bannerView:MZBannerView!
    var bannerList:[BannerItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        
        let contentView = UIScrollView.init(frame: CGRect.init(x: 0, y: Navi_Height, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-Navi_Height-Tabbar_Height));
        contentView.isPagingEnabled = true;
        contentView.contentSize = CGSize.init(width: SCREEN_WIDTH*2, height: 0);
        contentView.delegate = self;
        contentView.showsHorizontalScrollIndicator = false;
        self.view.addSubview(contentView);
        self.contentView = contentView;
        
        self.initHomePage();
//        self.initPersonPage();
        
        self.loadData();
    }
    
    //初始化音乐馆主界面
    func initHomePage() -> Void {
        let tableView = UITableView.init(frame: self.contentView.bounds);
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = .none;
        tableView.register(MusicHomePageCell.classForCoder(), forCellReuseIdentifier: "MusicHomePageCell");
        tableView.showsVerticalScrollIndicator = false;
        self.contentView.addSubview(tableView);
        self.homeTableView = tableView;
        
        let SCALE = SCREEN_WIDTH/375;
        
        let tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH/690*276+20+70*SCALE+20));
        tableHeaderView.isUserInteractionEnabled = true;
        self.bannerView = MZBannerView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH/690*276));
        self.bannerView.delegate = self;
        self.bannerView.tintColor = UIColor.white;
        self.bannerView.normalColor = RGB(r: 136, g: 136, b: 136);
        tableHeaderView.addSubview(self.bannerView);
        
        
        let iconNames = ["home_item_singer","home_item_top","home_item_category","home_item_mv"];
        let itemNames = ["歌手","排行","歌单","MV"];
        let itemWidth = SCREEN_WIDTH/4;
        
        for i in 0...3 {
            let itemView = UIView.init(frame: CGRect.init(x: itemWidth*CGFloat(i), y: SCREEN_WIDTH/690*276+20, width: itemWidth, height: 80*SCALE));
            itemView.isUserInteractionEnabled = true;
            itemView.tag = 200+i;
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(itemTap));
            itemView.addGestureRecognizer(tap);
            
            let iconView = UIImageView.init(frame: CGRect.init(x: (itemWidth-40*SCALE)/2, y: 0, width: 40*SCALE, height: 40*SCALE));
            iconView.image = UIImage.init(named: iconNames[i]);
            itemView.addSubview(iconView);
            let nameLB = UILabel.init(frame: CGRect.init(x: 0, y: 50*SCALE, width: itemWidth, height: 20*SCALE));
            nameLB.text = itemNames[i];
            nameLB.textAlignment = .center;
            nameLB.textColor = .black;
            nameLB.font = .systemFont(ofSize: 16);
            itemView.addSubview(nameLB);
            tableHeaderView.addSubview(itemView);
        }
        
        tableView.tableHeaderView = tableHeaderView;
    }
    
    @objc func itemTap(tap:UITapGestureRecognizer) -> Void {
        switch tap.view!.tag-200 {
        case 0:
            //歌手
            let vc = MusicSingerListVC.init();
            self.navigationController?.pushViewController(vc, animated: true);
            break;
        case 1:
            //排行
            let vc = MusicRankingCategoryVC.init();
            self.navigationController?.pushViewController(vc, animated: true);
            break;
        case 2:
            //歌单
            let vc = MusicSongListCategoryVC.init();
            self.navigationController?.pushViewController(vc, animated: true);
            break;
        case 3:
            //MV
            let vc = MusicMVListVC.init();
            self.navigationController?.pushViewController(vc, animated: true);
            break;
        default:
            break;
        }
    }
    
    //初始化个人中心
    func initPersonPage() -> Void {
        
    }
    
    
    func loadData() -> Void {
        self.loadBanner();
    }
    
    func loadBanner() -> Void {
        MZMusicAPIRequest.banner { (banners) in
            self.bannerList = banners;
            var images = [String]();
            for bannerItem in banners {
                images.append(bannerItem.pic_info.url);
            }
            self.bannerView.imageUrls = images;
            self.bannerView.dataArray = banners;
        }
    }

    func bannerView(_ bannerView: MZBannerView!, didSelectedIndex index: Int, data: Any!) {
        let banner = data as! BannerItem;
        if banner.type == 10012 {
            let vc = MusicMVDetailVC.init();
            vc.vid = banner.jump_info.url
            vc.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(vc, animated: true);
        } else if banner.type == 10002 {
            let vc = MusicAlbumDetailVC.init();
            vc.albumId = banner.jump_info.url
            self.navigationController?.pushViewController(vc, animated: true);
        } else {
            let webVC = MusicWebVC.init();
            webVC.url = banner.jump_info.url;
            webVC.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(webVC, animated: true);
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        let nav = self.navigationController as! MZNavigationController;
        nav.nameLB.isHidden = false;
        nav.searchView.isHidden = false;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        let nav = self.navigationController as! MZNavigationController;
        nav.nameLB.isHidden = true;
        nav.searchView.isHidden = true;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicHomePageCell") as! MusicHomePageCell;
        cell.type = indexPath.row;
        cell.itemTapCallback = {index in
            switch indexPath.row {
            case 0:
                let manager = MZMusicPlayerManager.shareManager
                manager.playMusic(playList: cell.list! as NSArray, playIndex: index)
                break;
            case 1:
                let vc = MusicSongListVC.init();
                vc.songListItem = (cell.list[index] as! SongListItem);
                self.navigationController?.pushViewController(vc, animated: true);
                break;
            case 2:
                let vc = MusicMVDetailVC.init();
                let mvItem = cell.list[index] as! MVItem
                vc.vid = mvItem.vid
                vc.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(vc, animated: true);
                break;
            default:
                break;
            }
        }
        cell.moreTapCallback = {
            switch indexPath.row {
            case 0:
                let vc = MusicRankingListVC.init();
                vc.rankingTitle = "热门歌曲";
                vc.rankingID = 27;
                self.navigationController?.pushViewController(vc, animated: true);
                break;
            case 1:
                let vc = MusicSongListListVC.init();
                vc.categoryID = 10000000;
                vc.categoryName = "热门歌单";
                self.navigationController?.pushViewController(vc, animated: true);
                break;
            case 2:
                let vc = MusicMVListVC.init();
                self.navigationController?.pushViewController(vc, animated: true);
                break;
            default:
                break;
            }
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let itemHeight = (SCREEN_WIDTH-24-20)/3;
        return itemHeight+80;
    }
}
