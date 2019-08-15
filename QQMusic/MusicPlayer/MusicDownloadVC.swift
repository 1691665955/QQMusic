//
//  MusicDownloadVC.swift
//  MyFirstSwiftProject
//
//  Created by 曾龙 on 17/4/9.
//  Copyright © 2017年 scinan. All rights reserved.
//

import UIKit
import MBProgressHUD
import MZExtension

class MusicDownloadVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView:UITableView!
    var taskList:NSArray!
    var segement:UISegmentedControl!
    
    //喜欢的音乐列表
    var loveMusicList:NSArray!
    //已下载的音乐列表
    var downloadMusicList:NSArray!
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.reloadData()
        self.segement.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.segement.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        let bgView = UIImageView.init(frame: self.view.bounds)
        bgView.image = UIImage.init(named: "QQListBack")
        self.view.addSubview(bgView)
        
        let titleBGView:UIView = UIView.init(frame: CGRect.init(x: 70, y: 0, width: SCREEN_WIDTH-140, height: 44))
        titleBGView.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.addSubview(titleBGView)
        
        let segement:UISegmentedControl = UISegmentedControl.init(frame: CGRect.init(x: 0, y: 5, width: SCREEN_WIDTH-140, height: 34))
        segement.insertSegment(withTitle: "已下载", at: 0, animated: false)
        segement.insertSegment(withTitle: "正在下载", at: 1, animated: false)
        segement.selectedSegmentIndex = 0
        titleBGView.addSubview(segement)
        titleBGView.tintColor = UIColor.white
        segement.addTarget(self, action: #selector(changeDownloadType(segement:)), for: UIControl.Event.valueChanged)
        self.segement = segement
        
        let backBtn = UIButton.init(type: UIButton.ButtonType.custom)
        backBtn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        backBtn.setImage(UIImage.init(named: "btn_返回_n"), for: UIControl.State.normal)
        backBtn.setImage(UIImage.init(named: "btn_返回_p"), for: UIControl.State.highlighted)
        backBtn.addTarget(self, action: #selector(back), for: UIControl.Event.touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)
        
        self.tableView = UITableView.init(frame: CGRect.init(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-113), style: UITableView.Style.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.backgroundColor = UIColor.clear
        self.view.addSubview(self.tableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name.init(DownloadTaskNotification.Finish.rawValue), object: nil)
    }
    
    @objc func changeDownloadType(segement:UISegmentedControl) {
        self.reloadData()
    }

    @objc func back() {
        self.navigationController!.popViewController(animated: true)
    }
    
    @objc func reloadData() {
        if self.segement.selectedSegmentIndex == 1 {
            self.taskList = NSArray.init(array: MZDownloadManager.sharedInstance.unFinishedTask())
        } else {
            self.taskList = NSArray.init(array: MZDownloadManager.sharedInstance.finishedTask())
        }
        self.tableView.reloadData()
        
        if self.segement.selectedSegmentIndex == 0 {
            let manager = MZMusicPlayerManager.shareManager
            let musicItem = manager.musicItem
            for i in 0..<self.taskList.count {
                let item:DownloadTask = self.taskList.object(at: i) as! DownloadTask
                let fileName = item.url.lastPathComponent
                let arr = fileName.components(separatedBy: ".")
                if arr[0] == musicItem?.mid {
                    self.tableView.selectRow(at: IndexPath.init(row: i, section: 0), animated: false, scrollPosition: UITableView.ScrollPosition.none)
                    return
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.segement.selectedSegmentIndex == 0 {
            var cell:NetworkMusicListCell! = tableView.dequeueReusableCell(withIdentifier: "networkMusicCell") as? NetworkMusicListCell
            if cell==nil {
                cell = NetworkMusicListCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "networkMusicCell")
            }
            let task:DownloadTask = self.taskList.object(at: indexPath.row) as! DownloadTask
            let fileName = task.url.lastPathComponent
            let arr = fileName.components(separatedBy: ".")
            cell.musicItem = MusicDatabaseManager.share.queryMusicDownload(songid: arr[0])
            return cell!
        } else {
            var cell:MusicDownloadCell! = tableView.dequeueReusableCell(withIdentifier: "musicDoawloadCell") as? MusicDownloadCell
            if cell==nil {
                cell = MusicDownloadCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "musicDoawloadCell")
            }
            cell.updateTask(task: self.taskList.object(at: indexPath.row) as! DownloadTask)
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.segement.selectedSegmentIndex == 0 {
            let musicList = MusicDatabaseManager.share.queryAllDownloadMusic()
            MZMusicPlayerManager.shareManager.playMusic(playList: musicList, playIndex: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.segement.selectedSegmentIndex == 0 {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction.init(style: UITableViewRowAction.Style.destructive, title: "删除") { (action, index) in
            let cell:NetworkMusicListCell = self.tableView(self.tableView, cellForRowAt: index) as! NetworkMusicListCell
            if cell.isSelected {
                MBProgressHUD.showError(error: "该歌曲正在播放，暂时不能删除")
                return
            }
            let item = cell.musicItem
            let downloadTask:DownloadTask = self.taskList.object(at: index.row) as! DownloadTask
            MZDownloadManager.sharedInstance.deleteTask(task: downloadTask)
            MusicDatabaseManager.share.deleteDownloadMusic(musicItem: item!)
            
            self.reloadData()
        }
        return [deleteAction]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
