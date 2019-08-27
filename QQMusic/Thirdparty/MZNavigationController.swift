//
//  MZNavigationController.swift
//  MyFirstSwiftProject
//
//  Created by 曾龙 on 17/3/17.
//  Copyright © 2017年 scinan. All rights reserved.
//

import UIKit

class MZNavigationController: UINavigationController,UINavigationControllerDelegate,UISearchControllerDelegate,UISearchBarDelegate {

    var nameLB:UILabel!
    var searchView:UIButton!
    var backBtn:UIButton!
    var searchController:MusicSearchController!
    var searchResultVC:MusicSearchResultVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self;
        
        let bar = UINavigationBar.appearance()
        bar.barTintColor = UIColor.white
        bar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        
        self.initUI(navigationBar: self.navigationBar);
    }
    
    func initUI(navigationBar:UINavigationBar) -> Void {
        nameLB = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: 100, height: 44))
        nameLB.text = "音乐馆";
        nameLB.font = UIFont.boldSystemFont(ofSize: 24);
        let maxSize = CGSize.init(width: CGFloat(Float.greatestFiniteMagnitude), height: 44);
        let size = nameLB.sizeThatFits(maxSize);
        nameLB.frame = CGRect.init(x: 20, y: 0, width: size.width, height: 44);
        navigationBar.addSubview(nameLB);
        
        
        searchView = UIButton.init(type: .custom);
        searchView.frame = CGRect.init(x: nameLB.frame.maxX+10, y: 8, width: SCREEN_WIDTH-(nameLB.frame.maxX+30), height: 28);
        searchView.layer.cornerRadius = 14;
        searchView.layer.masksToBounds = true;
        searchView.layer.borderWidth = 0.5;
        searchView.layer.borderColor = RGB(r: 223, g: 223, b: 223).cgColor;
        searchView.setImage(UIImage.init(named: "search"), for: .normal);
        searchView.setTitle("搜索", for: .normal);
        searchView.setTitleColor(RGB(r: 136, g: 136, b: 136), for: .normal)
        searchView.titleLabel?.font = .systemFont(ofSize: 12);
        searchView.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -2, bottom: 0, right: 2);
        searchView.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 2, bottom: 0, right: -2);
        searchView.addTarget(self, action: #selector(showSearchController), for: .touchUpInside);
        navigationBar.addSubview(searchView)
        
        backBtn = UIButton.init(type: .custom);
        backBtn.frame = CGRect.init(x: 0, y: 0, width: 50, height: 44);
        backBtn.contentHorizontalAlignment = .left;
        backBtn.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 12, bottom: 0, right: 0);
        backBtn.setImage(UIImage.init(named: "返回"), for: .normal);
        backBtn.addTarget(self, action: #selector(back), for: .touchUpInside);
        backBtn.isHidden = true;
        navigationBar.addSubview(backBtn);
    }
    
    @objc func back() -> Void {
        self.popViewController(animated: true);
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if navigationController.viewControllers.count > 1 {
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "   ", style: .done, target: nil, action: nil);
            self.backBtn.isHidden = false;
            self.navigationBar.bringSubviewToFront(self.backBtn);
        } else {
            self.backBtn.isHidden = true;
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if navigationController.viewControllers.count > 1 {
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "   ", style: .done, target: nil, action: nil);
            self.backBtn.isHidden = false;
            self.navigationBar.bringSubviewToFront(self.backBtn);
        } else {
            self.backBtn.isHidden = true;
        }
    }
    
    
    @objc func showSearchController() -> Void {
        searchResultVC = MusicSearchResultVC.init();
        searchController = MusicSearchController.init(searchResultsController: searchResultVC);
        searchController.delegate = self;
        searchController.searchResultsUpdater = searchResultVC;
        searchController.dimsBackgroundDuringPresentation = false;
        self.definesPresentationContext = true;
        
        let searchBar = searchController.searchBar;
        searchBar.delegate = self;
        searchBar.backgroundColor = RGB(r: 245, g: 245, b: 245);
        searchBar.placeholder = "搜索音乐、视频、歌手、专辑、歌单等";
        searchBar.tintColor = .black;
    
        //去除背景
        searchBar.setBackgroundImage(UIImage.getImageWithColor(color: .white), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        
        let textField = searchBar.value(forKey: "_searchField") as! UITextField;
        textField.font = UIFont.systemFont(ofSize: 14);
        textField.layer.borderWidth = 0.5;
        textField.layer.borderColor = RGB(r: 223, g: 223, b: 223).cgColor;
        textField.layer.cornerRadius = 18;
        textField.layer.masksToBounds = true;
        textField.tintColor = MainColor;
        
        self.present(searchController, animated: true, completion: nil);
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil && searchBar.text!.count > 0 {
            searchResultVC.keyword = searchBar.text
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
