//
//  MusicPlayerVC.swift
//  MyFirstSwiftProject
//
//  Created by 曾龙 on 17/3/25.
//  Copyright © 2017年 scinan. All rights reserved.
//

import UIKit
import AVFoundation
import MJRefresh
import MBProgressHUD

let MainColor = UIColor.init(red: 83/225.0, green: 185/255.0, blue: 106/255.0, alpha: 1)

enum MusicCategory:Int {
    case History
    case Download
    case Love
    case MV
}

class MusicPlayerVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating {
    var networkMusicTable:UITableView!
    var networkMusicTypes:NSArray!
    var networkMusicTypeNames:NSArray!
    
    
    //搜索栏相关
    var searchBar:UISearchBar!
    var searchController:UISearchController!
    var searchResultArray:NSMutableArray!
    var searchText:String!
    var searchResultVC:MusicTop100VC!
    
    //搜索位置
    var x = CGFloat(0)
    var y = CGFloat(120)
    
    //网络状态
//    var rachability:Reachability!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "音乐播放器测试"
        self.view.backgroundColor = UIColor.white
        
        /***********************网络状态*********************/
//        self.rachability = Reachability.init()
//        if self.rachability.isReachable {
//            print("网络可用")
//        } else {
//            print("网络不可用")
//        }
//
//        if self.rachability.isReachableViaWiFi {
//            print("WIFI")
//        } else if self.rachability.isReachableViaWWAN {
//            print("移动网络")
//        } else {
//            print("网络不可用")
//        }
//        
//        self.rachability.whenReachable = {reachability in
//        
//        }
//        
//        self.rachability.whenUnreachable = {reachability in
//            
//        }
//
//        do {
//            try self.rachability.startNotifier()
//        } catch  {
//            print("start notification error")
//        }
        /************************************************/
        
        let bgView = UIImageView.init(frame: self.view.bounds)
        bgView.image = UIImage.init(named: "QQListBack")
        self.view.addSubview(bgView)
        
        
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 99, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-148))
        scrollView.backgroundColor = UIColor.clear
        scrollView.contentSize = CGSize.init(width: SCREEN_WIDTH*2, height: 0)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentOffset = CGPoint.init(x: SCREEN_WIDTH, y: 0)
        self.view.addSubview(scrollView)
        
        
        self.networkMusicTable = UITableView.init(frame: CGRect.init(x: SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-148))
        self.networkMusicTable.delegate = self
        self.networkMusicTable.dataSource = self
        self.networkMusicTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.networkMusicTable.backgroundColor = UIColor.clear
        scrollView.addSubview(self.networkMusicTable)
        self.networkMusicTable.mj_header = MJRefreshHeader.init(refreshingBlock: { 
            self.networkMusicTable.mj_header.endRefreshing()
            self.networkMusicTable.reloadData()
        })
    
        self.networkMusicTypes = [26,5,6,3,17]
        self.networkMusicTypeNames = ["热歌榜","内地榜","港台榜","欧美榜","日本榜"]
        
        /****************************************上面为网络音乐**************************************************/
        let categoryNames = ["最近播放","下载","喜欢","语音识别"]
        let categoryType = [MusicCategory.History,MusicCategory.Download,MusicCategory.Love,MusicCategory.MV]
        for i in 0..<4 {
            let categoryBtn = UIButton.init(type: UIButton.ButtonType.custom)
            let x = (SCREEN_WIDTH-210.0)/2.0+CGFloat(110*(i%2))
            categoryBtn.frame = CGRect.init(x: x, y: 100.0+CGFloat(110*(i/2)), width: 100, height: 100)
            categoryBtn.setBackgroundImage(UIImage.init(named: "QQListBack"), for: UIControl.State.normal)
            categoryBtn.setTitle(categoryNames[i], for: UIControl.State.normal)
            categoryBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
            categoryBtn.addTarget(self, action:#selector(gotoCategoryVC(sender:)), for: UIControl.Event.touchUpInside)
            categoryBtn.tag = categoryType[i].rawValue
            scrollView.addSubview(categoryBtn)
        }
        self.initSearchBar()
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //搜索历史记录
    @objc func KeyboardWillHide() {
        if self.searchText.count>0 {
            var searchHistory:NSArray? = UserDefaults.standard.object(forKey: "searchHistory") as? NSArray
            if searchHistory == nil {
                searchHistory = NSArray.init()
            }
            let histrorys = NSMutableArray.init(array: searchHistory!)
            histrorys.insert(self.searchText as Any, at: 0)
            UserDefaults.standard.set(histrorys, forKey: "searchHistory")
        }
    }
    
    //获取横线
    func navigationBarLine(view:UIView) -> UIImageView? {
        if view.classForCoder == UIImageView.classForCoder() && view.bounds.size.height<=1.0 {
            return view as? UIImageView
        }
        
        for subView in view.subviews {
            let imageView = self.navigationBarLine(view: subView)
            if imageView != nil {
                return imageView
            }
        }
        return nil
    }
    
    //初始化searchBar
    func initSearchBar() {
        //去除NavigationBar横线
        let lineView = self.navigationBarLine(view: (self.navigationController?.navigationBar)!)
        if lineView != nil {
            lineView?.isHidden = true
        }
        
        self.searchBar = UISearchBar.init(frame: CGRect.init(x: 0, y: 64, width: SCREEN_WIDTH, height: 35))
        self.searchBar.backgroundColor = MainColor
        self.searchBar.subviews[0].subviews[0].removeFromSuperview()
        self.searchBar.placeholder = "搜索"
        self.searchBar.delegate = self
        self.view.addSubview(self.searchBar)
    }
    //搜索框文字更新
    func updateSearchResults(for searchController: UISearchController) {
        self.searchText = searchController.searchBar.text
        MZMusicAPIRequest.searchMusicList(keyword: self.searchText, type: "song", pageSize: 20, page: 1, format: 1) { (musicList) in
            self.searchResultArray = NSMutableArray.init(array: musicList)
            if self.searchResultArray.count>0 {
                let bgView = self.searchController.view.viewWithTag(100)
                bgView?.isHidden = true
            }
            self.searchResultVC.musicList = self.searchResultArray
            self.searchResultVC.tableView.reloadData()
        }
        
        if self.searchText.count == 0{
            let bgView = self.searchController.view.viewWithTag(100)
            bgView?.isHidden = false
            for view in (bgView?.subviews)! {
                view.removeFromSuperview()
            }
            
            let tipsLB = UILabel.init(frame: CGRect.init(x: 20, y: 80, width: 150, height: 30))
            tipsLB.text = "搜索历史记录"
            tipsLB.textColor = UIColor.white
            bgView?.addSubview(tipsLB)
            
            let clearBtn = UIButton.init(type: UIButton.ButtonType.custom)
            clearBtn.frame = CGRect.init(x: 220, y: 80, width: 80, height: 30)
            clearBtn.setTitle("清空", for: UIControl.State.normal)
            clearBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
            clearBtn.backgroundColor = UIColor.clear
            clearBtn.addTarget(self, action: #selector(clearSearchHistory), for: UIControl.Event.touchUpInside)
            bgView?.addSubview(clearBtn)
            
            
            x = 0
            y = 120
            var searchHistory:NSArray? = UserDefaults.standard.object(forKey: "searchHistory") as? NSArray
            if searchHistory == nil {
                searchHistory = NSArray.init()
            }
            let historys = NSArray.init(array: searchHistory!)
            
            for str in historys {
                let history = str as! String
                let btn = UIButton.init(type: UIButton.ButtonType.custom)
                btn.setTitle(history, for: UIControl.State.normal)
                btn.backgroundColor = UIColor.white
                btn.layer.masksToBounds = true
                btn.layer.cornerRadius = 5
                btn.setTitleColor(MainColor, for: UIControl.State.normal)
                let maxSize = CGSize.init(width: CGFloat(Float.greatestFiniteMagnitude), height: 30)
                let size = btn.titleLabel?.sizeThatFits(maxSize)
                if x+(size?.width)!>SCREEN_WIDTH-60 {
                    x=0
                    y=y+40
                }
                btn.frame = CGRect.init(x: x+20, y: y, width: (size?.width)!+20, height: 30)
                btn.addTarget(self, action: #selector(historyClicked(sender:)), for: UIControl.Event.touchUpInside)
                bgView?.addSubview(btn)
                x = btn.frame.maxX
            }
        }
    }
    
    //历史记录点击事件
    @objc func historyClicked(sender:UIButton) {
        self.searchController.searchBar.text =  sender.titleLabel?.text
    }
    
    //清空历史记录
    @objc func clearSearchHistory() {
        let bgView = self.searchController.view.viewWithTag(100)
        bgView?.isHidden = false
        for view in (bgView?.subviews)! {
            view.removeFromSuperview()
        }
        
        let tipsLB = UILabel.init(frame: CGRect.init(x: 20, y: 80, width: 150, height: 30))
        tipsLB.text = "搜索历史记录"
        tipsLB.textColor = UIColor.white
        bgView?.addSubview(tipsLB)
        
        let clearBtn = UIButton.init(type: UIButton.ButtonType.custom)
        clearBtn.frame = CGRect.init(x: 220, y: 80, width: 80, height: 30)
        clearBtn.setTitle("清空", for: UIControl.State.normal)
        clearBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        clearBtn.backgroundColor = UIColor.clear
        clearBtn.addTarget(self, action: #selector(clearSearchHistory), for: UIControl.Event.touchUpInside)
        bgView?.addSubview(clearBtn)
        
        var searchHistory:NSArray? = UserDefaults.standard.object(forKey: "searchHistory") as? NSArray
        if searchHistory == nil {
            searchHistory = NSArray.init()
        }
        let histrorys = NSMutableArray.init(array: searchHistory!)
        histrorys.removeAllObjects()
        UserDefaults.standard.set(histrorys, forKey: "searchHistory")
    }
    
    //主界面搜索框点击
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchResultArray = NSMutableArray.init()
        self.searchResultVC = MusicTop100VC()
        self.searchResultVC.refreshData = { page in
            MZMusicAPIRequest.searchMusicList(keyword: self.searchText, type: "song", pageSize: 20, page: page, format: 1) { (musicList) in
                for item in musicList {
                    self.searchResultArray.add(item)
                }
                if page == 1 {
                    self.searchResultArray = NSMutableArray.init(array: musicList)
                    self.searchResultVC.tableView.mj_header.endRefreshing()
                } else {
                    self.searchResultVC.tableView.mj_footer.endRefreshing()
                }
                if self.searchResultArray.count>0 {
                    let bgView = self.searchController.view.viewWithTag(100)
                    bgView?.isHidden = true
                }
                self.searchResultVC.musicList = self.searchResultArray
                self.searchResultVC.tableView.reloadData()
            }
        }
        self.searchResultVC.isSearch = true
        self.searchResultVC.musicList = self.searchResultArray
        
        self.searchController = UISearchController.init(searchResultsController: self.searchResultVC)
        self.searchController.delegate = self
        self.searchController.searchResultsUpdater = self
        self.searchController.view.backgroundColor = MainColor
        self.searchController.searchBar.placeholder = "搜索"
        self.searchController.searchBar.subviews[0].subviews[0].removeFromSuperview()
        
        self.searchController.view.isUserInteractionEnabled = true
        let bgView = UIImageView.init(frame: self.view.bounds)
        bgView.image = UIImage.init(named: "QQListBack")
        bgView.tag = 100
        bgView.isUserInteractionEnabled = true
        self.searchController.view.insertSubview(bgView, at: 1)
        
        self.present(self.searchController, animated: true) {
            self.searchBar.isHidden = true
            self.view.isHidden = true
        }
    }
    
    //细节处理
    func didDismissSearchController(_ searchController: UISearchController) {
        self.searchBar.isHidden = false
        self.view.isHidden = false
        
        let bgView = self.searchController.view.viewWithTag(100)
        bgView?.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.isHidden = false
        self.view.isHidden = false
    }
    
    @objc func gotoCategoryVC(sender:UIButton) {
        let categoryNames = ["最近播放","下载","喜欢","语音识别"]
        if sender.tag == MusicCategory.History.rawValue {
            let databaseManager = MusicDatabaseManager.share
            let musicList = databaseManager.queryHistoryMusics()
            let categoryVC = MusicTop100VC()
            categoryVC.musicList = NSMutableArray.init(array: musicList)
            categoryVC.typeName = categoryNames[0]
            self.navigationController?.pushViewController(categoryVC, animated: true)
        } else if sender.tag == MusicCategory.Love.rawValue {
            let databaseManager = MusicDatabaseManager.share
            let musicList = databaseManager.queryAllLoveMusic()
            let categoryVC = MusicTop100VC()
            categoryVC.musicList = NSMutableArray.init(array: musicList)
            categoryVC.typeName = categoryNames[2]
            self.navigationController?.pushViewController(categoryVC, animated: true)
        } else if sender.tag == MusicCategory.Download.rawValue {
            let categoryVC = MusicDownloadVC()
            self.navigationController?.pushViewController(categoryVC, animated: true)
        } else {
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.networkMusicTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:MusicCategoryCell! = tableView.dequeueReusableCell(withIdentifier: "category") as? MusicCategoryCell
        if cell==nil {
            cell = MusicCategoryCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "category")
        }
        cell.musicType = self.networkMusicTypes.object(at: indexPath.row) as? Int
        cell.musicTypeName = self.networkMusicTypeNames.object(at: indexPath.row) as? String
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let top100VC = MusicTop100VC()
        top100VC.typeName = self.networkMusicTypeNames.object(at: indexPath.row) as? String
        let cell:MusicCategoryCell = tableView.cellForRow(at: indexPath) as! MusicCategoryCell
        if cell.musicList == nil {
            MBProgressHUD.showError(error: "尚未加载成功")
            return
        }
        top100VC.musicList = NSMutableArray.init(array: cell.musicList);
        self.navigationController?.pushViewController(top100VC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 90
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
