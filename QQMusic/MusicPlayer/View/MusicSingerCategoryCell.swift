//
//  MusicSingerCategoryCell.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/21.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit

class MusicSingerCategoryCell: UICollectionViewCell {
    
    var nameLB:UILabel!
    var categoryItem:SingerCategoryItem! {
        didSet {
            nameLB.text = categoryItem.name
        }
    }
    var id:Int! {
        didSet {
            if id == categoryItem.id {
                nameLB.backgroundColor = MainColor;
                nameLB.textColor = .white;
            } else {
                nameLB.backgroundColor = .white;
                nameLB.textColor = .black;
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.initUI()
    }
    
    func initUI() -> Void {
        self.backgroundColor = .clear;
        
        nameLB = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 30));
        nameLB.layer.cornerRadius = 15;
        nameLB.layer.masksToBounds = true;
        nameLB.backgroundColor = .white;
        nameLB.textColor = .black;
        nameLB.textAlignment = .center;
        nameLB.font = .systemFont(ofSize: 10)
        self.addSubview(nameLB);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
