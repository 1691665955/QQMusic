//
//  MZNavigationController.swift
//  MyFirstSwiftProject
//
//  Created by 曾龙 on 17/3/17.
//  Copyright © 2017年 scinan. All rights reserved.
//

import UIKit

class MZNavigationController: UINavigationController,UINavigationControllerDelegate {

    var nameLB:UILabel!
    var searchBar:UISearchBar!
    var backBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self;
        
        let bar = UINavigationBar.appearance()
        bar.barTintColor = UIColor.white
        bar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        
        self.initUI(navigationBar: self.navigationBar);
    }
    
    func initUI(navigationBar:UINavigationBar) -> Void {
        let nameLB = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: 100, height: 44))
        nameLB.text = "音乐馆";
        nameLB.font = UIFont.boldSystemFont(ofSize: 24);
        let maxSize = CGSize.init(width: CGFloat(Float.greatestFiniteMagnitude), height: 44);
        let size = nameLB.sizeThatFits(maxSize);
        nameLB.frame = CGRect.init(x: 20, y: 0, width: size.width, height: 44);
        navigationBar.addSubview(nameLB);
        self.nameLB = nameLB;
        
        let searchBar = UISearchBar.init(frame: CGRect.init(x: nameLB.frame.maxX+10, y: 8, width: SCREEN_WIDTH-(nameLB.frame.maxX+20), height: 28))
        searchBar.placeholder = "搜索";
        navigationBar.addSubview(searchBar);
        self.searchBar = searchBar;
        
        let textField = searchBar.value(forKey: "_searchField") as! UITextField;
        textField.layer.cornerRadius = 14;
        textField.layer.masksToBounds = true;
        textField.layer.borderWidth = 0.5;
        textField.layer.borderColor = RGB(r: 223, g: 223, b: 223).cgColor;
        textField.font = UIFont.systemFont(ofSize: 16);
        
        let backBtn = UIButton.init(type: .custom);
        backBtn.frame = CGRect.init(x: 0, y: 0, width: 50, height: 44);
        backBtn.contentHorizontalAlignment = .left;
        backBtn.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 12, bottom: 0, right: 0);
        backBtn.setImage(UIImage.init(named: "返回"), for: .normal);
        backBtn.addTarget(self, action: #selector(back), for: .touchUpInside);
        backBtn.isHidden = true;
        navigationBar.addSubview(backBtn);
        self.backBtn = backBtn;
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
