//
//  MusicSingerListVC.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/21.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit

class MusicSingerListVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate {

    var tableView:UITableView!
    var areaCollectionView:UICollectionView!
    var sexCollectionView:UICollectionView!
    var genreCollectionView:UICollectionView!
    var singerCategory:SingerCategory!
    var singerList=[[ArtistItem]]()
    
    var sexId = -100
    var areaId = -100
    var genre = -100
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RGB(r: 245, g: 245, b: 245);
        self.title = "歌手";
        
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: Navi_Height, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-Navi_Height-Tabbar_Height), style: .plain);
        tableView.backgroundColor = .clear;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = .none;
        tableView.sectionIndexColor = RGB(r: 136, g: 136, b: 136);
        tableView.sectionIndexBackgroundColor = .clear;
        tableView.register(MusicSingerListCell.classForCoder(), forCellReuseIdentifier: "MusicSingerListCell")
        self.view.addSubview(tableView);
        
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 130));
        
        let areaLayout = UICollectionViewFlowLayout.init();
        areaLayout.itemSize = CGSize.init(width: 50, height: 30);
        areaLayout.minimumInteritemSpacing = 10;
        areaLayout.sectionInset = UIEdgeInsets.init(top: 5, left: 15, bottom: 5, right: 15);
        areaLayout.scrollDirection = .horizontal;
        
        areaCollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 5, width: SCREEN_WIDTH, height: 40), collectionViewLayout: areaLayout);
        areaCollectionView.showsHorizontalScrollIndicator = false;
        areaCollectionView.backgroundColor = .clear;
        areaCollectionView.dataSource = self;
        areaCollectionView.delegate = self;
        areaCollectionView.register(MusicSingerCategoryCell.classForCoder(), forCellWithReuseIdentifier: "MusicSingerCategoryCell")
        header.addSubview(areaCollectionView);
        
        let sexLayout = UICollectionViewFlowLayout.init();
        sexLayout.itemSize = CGSize.init(width: 50, height: 30);
        sexLayout.minimumInteritemSpacing = 10;
        sexLayout.sectionInset = UIEdgeInsets.init(top: 5, left: 15, bottom: 5, right: 15);
        sexLayout.scrollDirection = .horizontal;
        
        sexCollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 45, width: SCREEN_WIDTH, height: 40), collectionViewLayout: sexLayout);
        sexCollectionView.showsHorizontalScrollIndicator = false;
        sexCollectionView.backgroundColor = .clear;
        sexCollectionView.dataSource = self;
        sexCollectionView.delegate = self;
        sexCollectionView.register(MusicSingerCategoryCell.classForCoder(), forCellWithReuseIdentifier: "MusicSingerCategoryCell")
        header.addSubview(sexCollectionView);
        
        let genreLayout = UICollectionViewFlowLayout.init();
        genreLayout.itemSize = CGSize.init(width: 50, height: 30);
        genreLayout.minimumInteritemSpacing = 10;
        genreLayout.sectionInset = UIEdgeInsets.init(top: 5, left: 15, bottom: 5, right: 15);
        genreLayout.scrollDirection = .horizontal;
        
        genreCollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 85, width: SCREEN_WIDTH, height: 40), collectionViewLayout: genreLayout);
        genreCollectionView.showsHorizontalScrollIndicator = false;
        genreCollectionView.backgroundColor = .clear;
        genreCollectionView.dataSource = self;
        genreCollectionView.delegate = self;
        genreCollectionView.register(MusicSingerCategoryCell.classForCoder(), forCellWithReuseIdentifier: "MusicSingerCategoryCell")
        header.addSubview(genreCollectionView);
        
        tableView.tableHeaderView = header;
        
        self.loadHeaderData();
    }
    
    func loadHeaderData() -> Void {
        MZMusicAPIRequest.getArtistCategory { (category) in
            if category != nil {
                self.singerCategory = category;
                self.areaCollectionView.reloadData();
                self.sexCollectionView.reloadData();
                self.genreCollectionView.reloadData();
                for _ in category!.index {
                    self.singerList.append([]);
                }
                self.loadData();
            }
        }
    }
    
    func loadData() -> Void {
        for (index,item) in self.singerCategory.index.enumerated() {
            MZMusicAPIRequest.getSingerList(sexId: sexId, areaId: areaId, genre: genre, index: item.id, pageSize: 30, page: 1) { (list) in
                self.singerList[index] = list;
                self.tableView.reloadData();
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.singerList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.singerList[section].count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicSingerListCell") as! MusicSingerListCell
        cell.artist = self.singerList[indexPath.section][indexPath.row];
        return cell;
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MusicSingerDetailVC.init();
        vc.artist = self.singerList[indexPath.section][indexPath.row];
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 40));
        header.backgroundColor = RGB(r: 245, g: 245, b: 245);
        let titleLB = UILabel.init(frame: CGRect.init(x: 15, y: 0, width: SCREEN_WIDTH-20, height: 40));
        titleLB.textColor = RGB(r: 136, g: 136, b: 136);
        titleLB.font = .systemFont(ofSize: 12);
        titleLB.text = self.singerCategory.index[section].name;
        header.addSubview(titleLB);
        return header;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40;
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var names = [String]();
        if self.singerCategory != nil {
            for item in self.singerCategory.index {
                names.append(item.name);
            }
        }
        return names;
    }
    
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.collectionViewLayout.invalidateLayout()
        if collectionView == areaCollectionView {
            return self.singerCategory == nil ? 0 : self.singerCategory.area.count;
        } else if collectionView == sexCollectionView {
            return self.singerCategory == nil ? 0 : self.singerCategory.sex.count;
        } else {
            return self.singerCategory == nil ? 0 : self.singerCategory.genre.count;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MusicSingerCategoryCell", for: indexPath) as! MusicSingerCategoryCell;
        if collectionView == areaCollectionView {
            cell.categoryItem = self.singerCategory.area[indexPath.row];
            cell.id = areaId;
        } else if collectionView == sexCollectionView {
            cell.categoryItem = self.singerCategory.sex[indexPath.row];
            cell.id = sexId;
        } else {
            cell.categoryItem = self.singerCategory.genre[indexPath.row];
            cell.id = genre;
        }
        return cell;
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == areaCollectionView {
            areaId = self.singerCategory.area[indexPath.row].id;
            areaCollectionView.reloadData();
        } else if collectionView == sexCollectionView {
            sexId = self.singerCategory.sex[indexPath.row].id;
            sexCollectionView.reloadData();
        } else {
            genre = self.singerCategory.genre[indexPath.row].id;
            genreCollectionView.reloadData();
        }
        self.loadData();
    }
    

}
