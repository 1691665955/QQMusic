//
//  MusicSubListCell.swift
//  MyFirstSwiftProject
//
//  Created by 曾龙 on 17/3/30.
//  Copyright © 2017年 scinan. All rights reserved.
//

import UIKit

class MusicSubListCell: UITableViewCell {

    var musicItem:MusicItem!{
        didSet{
        self.titleLB.text = String.init(format: "%@ - %@", arguments: [musicItem.songname!,musicItem.singername!])
        }
    }
    var titleLB:UILabel!
    var authorLB:UILabel!
    var midLB:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCell.SelectionStyle.none;
        self.setUpUI();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpUI() {
        
        self.backgroundColor = UIColor.clear

        self.titleLB = UILabel.init(frame: CGRect.init(x: 20, y: 10, width: SCREEN_WIDTH-40, height: 30))
        self.titleLB.backgroundColor = UIColor.clear
        self.titleLB.textColor = UIColor.white
        self.titleLB.textAlignment = NSTextAlignment.left
        self.titleLB.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(self.titleLB)
        
        let lineLB = UILabel.init(frame: CGRect.init(x: 10, y: 49, width: SCREEN_WIDTH-20, height: 1))
        lineLB.backgroundColor = UIColor.gray
        self.addSubview(lineLB)
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
