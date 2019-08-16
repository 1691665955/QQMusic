//
//  MusicRankingCategoryVC.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/16.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit

class MusicRankingCategoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white;
        self.title = "QQ音乐排行榜";
        
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: Navi_Height, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-Navi_Height-Tabbar_Height), style: .grouped);
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = .none;
        tableView.backgroundColor = RGB(r: 245, g: 245, b: 245);
        tableView.register(MusicRankingCategoryTopCell.classForCoder(), forCellReuseIdentifier: "MusicRankingCategoryTopCell")
        tableView.register(MusicRankingCategoryOtherCell.classForCoder(), forCellReuseIdentifier: "MusicRankingCategoryOtherCell")
        self.view.addSubview(tableView);
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3;
        }
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MusicRankingCategoryTopCell") as! MusicRankingCategoryTopCell;
            cell.type = indexPath.row;
            return cell;
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MusicRankingCategoryOtherCell") as! MusicRankingCategoryOtherCell;
            cell.type = indexPath.section;
            cell.tapRanking = {(title,id) in
                let vc = MusicRankingListVC.init();
                vc.rankingTitle = title;
                vc.rankingID = id;
                self.navigationController?.pushViewController(vc, animated: true);
            }
            return cell;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let titles = ["流行指数榜","热歌榜","新歌榜"]
            let ids = [4,26,27];
            let vc = MusicRankingListVC.init();
            vc.rankingTitle = titles[indexPath.row];
            vc.rankingID = ids[indexPath.row];
            self.navigationController?.pushViewController(vc, animated: true);
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100;
        } else if indexPath.section == 3 {
            let itemWidth = (SCREEN_WIDTH-24-20)/3
            return itemWidth*3+30;
        } else {
            let itemWidth = (SCREEN_WIDTH-24-20)/3
            return itemWidth*2+20;
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titles = ["巅峰榜","地区榜","特色榜","全球榜"]
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 50));
        header.backgroundColor = .clear;
        let titleLB = UILabel.init(frame: CGRect.init(x: 16, y: 25, width: 200, height: 20));
        titleLB.font = .systemFont(ofSize: 18);
        titleLB.text = titles[section];
        header.addSubview(titleLB);
        return header;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01;
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 0.01));
        footer.backgroundColor = .clear;
        return footer;
    }
    
}
