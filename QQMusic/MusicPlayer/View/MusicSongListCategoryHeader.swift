//
//  MusicSongListCategoryHeader.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/17.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit

class MusicSongListCategoryHeader: UICollectionReusableView {
    var categoryNameLB:UILabel!
    var categoryName:String! {
        didSet {
            categoryNameLB.text = categoryName;
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        categoryNameLB = UILabel.init(frame: CGRect.init(x: 10, y: 10, width: SCREEN_WIDTH-20, height: 20));
        categoryNameLB.textColor = RGB(r: 136, g: 136, b: 136);
        categoryNameLB.font = .systemFont(ofSize: 16);
        self.addSubview(categoryNameLB);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
