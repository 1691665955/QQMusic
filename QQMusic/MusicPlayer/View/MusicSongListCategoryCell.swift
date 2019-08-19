//
//  MusicSongListCategoryCell.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/16.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit

class MusicSongListCategoryCell: UICollectionViewCell {
    
    var nameLB:UILabel!
    var model:SongListCategoryItem! {
        didSet {
            self.nameLB.text = model!.categoryName.htmlText();
            self.nameLB.textColor = RGB(r: CGFloat(arc4random()%256), g: CGFloat(arc4random()%256), b: CGFloat(arc4random()%256));
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.initUI();
    }
    
    func initUI() -> Void {
        nameLB = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: (SCREEN_WIDTH-40)/3, height: 40));
        nameLB.backgroundColor = RGBA(r: 223, g: 223, b: 223, a: 0.5)
        nameLB.layer.cornerRadius = 5;
        nameLB.layer.masksToBounds = true;
        nameLB.textColor = .white
        nameLB.textAlignment = .center;
        nameLB.font = .systemFont(ofSize: 12);
        self.addSubview(nameLB);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
