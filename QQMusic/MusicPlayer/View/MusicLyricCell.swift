//
//  MusicLyricCell.swift
//  MyFirstSwiftProject
//
//  Created by 曾龙 on 17/3/27.
//  Copyright © 2017年 scinan. All rights reserved.
//

import UIKit

class MusicLyricCell: UITableViewCell {

    var titleLB:UILabel!
    var height:CGFloat!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCell.SelectionStyle.none;
        self.setUpUI();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpUI() {
        self.height = 40
        self.backgroundColor = UIColor.clear
        self.titleLB = UILabel.init(frame: CGRect.init(x: 20, y: 10, width: SCREEN_WIDTH-40, height: 20))
        self.titleLB.backgroundColor = UIColor.clear
        self.titleLB.textColor = UIColor.white
        self.titleLB.textAlignment = NSTextAlignment.center
        self.titleLB.numberOfLines = 0
        self.addSubview(self.titleLB)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if self.isSelected {
            self.titleLB.textColor = MainColor
        } else {
            self.titleLB.textColor = UIColor.white
        }
    }
}
