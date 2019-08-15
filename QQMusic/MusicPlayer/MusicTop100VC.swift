//
//  MusicTop100VC.swift
//  MyFirstSwiftProject
//
//  Created by 曾龙 on 17/4/1.
//  Copyright © 2017年 scinan. All rights reserved.
//

import UIKit
import MJRefresh

typealias refresh = (Int)->Void

class MusicTop100VC: UIViewController,UITableViewDelegate,UITableViewDataSource,MZMusicPlayerManagerDelegate {

    var musicList:NSMutableArray!
    var tableView:UITableView!
    var typeName:String!{
        didSet{
            self.title = typeName
        }
    }
    //喜欢的音乐列表
    var loveMusicList:NSArray!
    //已下载的音乐列表
    var downloadMusicList:NSArray!
    

    //搜索
    var page:Int = 1
    var isSearch:Bool?
    var refreshData:refresh?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let bgView = UIImageView.init(frame: self.view.bounds)
        bgView.image = UIImage.init(named: "QQListBack")
        self.view.addSubview(bgView)
        
        self.tableView = UITableView.init(frame: CGRect.init(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-113))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.backgroundColor = UIColor.clear
        self.view.addSubview(self.tableView)
        
        if self.isSearch == true {
            self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
                self.page = 1
                self.refreshData!(self.page)
            })
            
            self.tableView.mj_footer = MJRefreshAutoFooter.init(refreshingBlock: {
                self.page += 1
                self.refreshData!(self.page)
            })
        }
        
        let backBtn = UIButton.init(type: UIButton.ButtonType.custom)
        backBtn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        backBtn.setImage(UIImage.init(named: "btn_返回_n"), for: UIControl.State.normal)
        backBtn.setImage(UIImage.init(named: "btn_返回_p"), for: UIControl.State.highlighted)
        backBtn.addTarget(self, action: #selector(back), for: UIControl.Event.touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)

        if self.typeName != nil && self.typeName == "最近播放" {
            let clearBtn = UIButton.init(type: UIButton.ButtonType.custom)
            clearBtn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
            clearBtn.setTitle("清空", for: UIControl.State.normal)
            clearBtn.addTarget(self, action: #selector(clearPlayHistory), for: UIControl.Event.touchUpInside)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: clearBtn)
        }
        
        let manager = MZMusicPlayerManager.shareManager
        let musicItem = manager.musicItem
        for i in 0..<self.musicList.count {
            let item:MusicItem = self.musicList.object(at: i) as! MusicItem
            if item.mid == musicItem?.mid {
                self.tableView.selectRow(at: IndexPath.init(row: i, section: 0), animated: false, scrollPosition: UITableView.ScrollPosition.none)
                return
            }
        }
    }

    @objc func back() {
        self.navigationController!.popViewController(animated: true) 
    }
    
    @objc func clearPlayHistory() {
        let alert = UIAlertController.init(title: nil, message: "确定要清空播放历史吗", preferredStyle: UIAlertController.Style.alert)
        let action1 = UIAlertAction.init(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
        let action2 = UIAlertAction.init(title: "确定", style: UIAlertAction.Style.default) { (alertAction) in
            MusicDatabaseManager.share.deleteHistoryMusics()
            self.musicList.removeAllObjects()
            self.tableView.reloadData()
        }
        alert.addAction(action1)
        alert.addAction(action2)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:NetworkMusicListCell! = tableView.dequeueReusableCell(withIdentifier: "networkMusicCell") as? NetworkMusicListCell
        if cell==nil {
            cell = NetworkMusicListCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "networkMusicCell")
        }
        let musicItem:MusicItem = self.musicList.object(at: indexPath.row) as! MusicItem
        cell?.musicItem = musicItem
        cell.loveCallback = {
            if self.typeName != nil && self.typeName == "喜欢" {
                self.musicList.removeObject(at: indexPath.row)
                self.tableView.reloadData()
            }
        }
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let manager = MZMusicPlayerManager.shareManager
        manager.playMusic(playList: self.musicList, playIndex: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
