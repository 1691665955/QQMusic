//
//  MusicSearchController.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/22.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit

class MusicSearchController: UISearchController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = RGB(r: 245, g: 245, b: 245);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let vc = self.searchResultsController as! MusicSearchResultVC
        vc.originY = self.searchBar.subviews.first?.subviews.first?.frame.height
    }

}
