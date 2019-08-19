//
//  MusicSongListCategoryVC.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/16.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit

class MusicSongListCategoryVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    var collectionView:UICollectionView!
    var categoryGroupList=[SongListCategoryGroupItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white;
        self.title = "歌单分类";
        
        let layout = UICollectionViewFlowLayout.init();
        layout.itemSize = CGSize.init(width: (SCREEN_WIDTH-40)/3, height: 40);
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10);
        layout.minimumLineSpacing = 9;
        layout.minimumInteritemSpacing = 9;
        layout.headerReferenceSize = CGSize.init(width: SCREEN_WIDTH, height: 40);
        layout.footerReferenceSize = CGSize.init(width: SCREEN_WIDTH, height: 0);
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: Navi_Height, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-Navi_Height-Tabbar_Height), collectionViewLayout: layout);
        collectionView.backgroundColor = .white;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 10, right: 0);
        collectionView.register(MusicSongListCategoryCell.classForCoder(), forCellWithReuseIdentifier: "MusicSongListCategoryCell");
        collectionView.register(MusicSongListCategoryHeader.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MusicSongListCategoryHeader")
        self.view.addSubview(collectionView);
        
        MZMusicAPIRequest.getSongListCategory { (list) in
            self.categoryGroupList = list;
            self.collectionView.reloadData();
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.categoryGroupList.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoryGroupList[section].items.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MusicSongListCategoryCell", for: indexPath) as! MusicSongListCategoryCell;
        cell.model = self.categoryGroupList[indexPath.section].items[indexPath.row];
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MusicSongListListVC.init();
        vc.categoryID = self.categoryGroupList[indexPath.section].items[indexPath.row].categoryId;
        vc.categoryName = self.categoryGroupList[indexPath.section].items[indexPath.row].categoryName;
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MusicSongListCategoryHeader", for: indexPath) as! MusicSongListCategoryHeader;
            header.categoryName = self.categoryGroupList[indexPath.section].categoryGroupName;
            return header;
        } else {
            return UICollectionReusableView.init();
        }
    }

}
