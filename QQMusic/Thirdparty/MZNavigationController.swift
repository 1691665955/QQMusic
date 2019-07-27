//
//  MZNavigationController.swift
//  MyFirstSwiftProject
//
//  Created by 曾龙 on 17/3/17.
//  Copyright © 2017年 scinan. All rights reserved.
//

import UIKit

class MZNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let bar = UINavigationBar.appearance()
        bar.barTintColor = MainColor
//        bar.setBackgroundImage(UIImage.init(named: "navibar"), for: UIBarMetrics.default)
//        bar.backgroundColor = MainColor
        bar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
