//
//  MusicSongListListVC.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/17.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit
import MJRefresh

class MusicSongListListVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    var categoryID:Int!
    var categoryName:String! {
        didSet {
            self.title = categoryName;
        }
    }
    var page:Int!
    var collectionView:UICollectionView!
    var list = [SongListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white;
        
        let layout = UICollectionViewFlowLayout.init();
        layout.itemSize = CGSize.init(width: (SCREEN_WIDTH-36)/2, height: (SCREEN_WIDTH-36)/2+40);
        layout.sectionInset = UIEdgeInsets.init(top: 12, left: 12, bottom: 12, right: 12);
        layout.minimumLineSpacing = 12;
        layout.minimumInteritemSpacing = 12;
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: Navi_Height, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-Navi_Height-Tabbar_Height), collectionViewLayout: layout);
        collectionView.backgroundColor = .white;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.register(MusicSongListListCell.classForCoder(), forCellWithReuseIdentifier: "MusicSongListListCell");
        collectionView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMore))
        self.view.addSubview(collectionView);
        
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
        MZMusicAPIRequest.getHotSongList(categoryID: self.categoryID, sortId: 1, pageSize: 20, page: page) { (songListArray:[SongListItem]) in
            self.collectionView.mj_footer.endRefreshing();
            self.list.append(contentsOf: songListArray);
            self.collectionView.reloadData();
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MusicSongListListCell", for: indexPath) as! MusicSongListListCell;
        cell.model = self.list[indexPath.row];
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MusicSongListVC.init();
        vc.songListItem = self.list[indexPath.row];
        self.navigationController?.pushViewController(vc, animated: true);
    }

}
