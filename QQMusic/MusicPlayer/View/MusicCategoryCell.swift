//
//  MusicCategoryCell.swift
//  MyFirstSwiftProject
//
//  Created by 曾龙 on 17/3/31.
//  Copyright © 2017年 scinan. All rights reserved.
//

import UIKit

typealias failure = () -> Void

class MusicCategoryCell: UITableViewCell {

    var iconView:UIImageView!
    var typeNameLB:UILabel!
    var musicList:NSArray!
    
    var musicType:Int!{
        didSet{
            MZMusicAPIRequest.getHotMusicList(id: musicType, pageSize: 3, page: 0, format: 0) { (musiclist:[MusicItem]) in
                self.musicList = musiclist as NSArray
                if musiclist.count == 0 {
                    return
                }
                for i in 0..<3{
                    let item:MusicItem = self.musicList.object(at: i) as! MusicItem
                    let songNameLB = UILabel.init(frame: CGRect.init(x: 95.0, y: 80.0/3.0*CGFloat(i), width: 180.0, height: 80.0/3.0))
                    songNameLB.backgroundColor = UIColor.clear
                    songNameLB.font = UIFont.systemFont(ofSize: 15)
                    let str = String.init(format: "%d %@ - %@", i+1,item.title!,item.singer!)
                    
                    let att = NSMutableAttributedString.init(string: str)
                    att.addAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], range: NSRange.init(location: 0, length: item.title.count+3))
                    att.addAttributes([NSAttributedString.Key.foregroundColor:UIColor.gray], range: NSRange.init(location: item.title.count+3, length: str.count-item.title.count-3))
                    songNameLB.attributedText = att
                    
                    self.addSubview(songNameLB)
                    
                    if i == 0 {
                        self.iconView.sd_setImage(with: URL.init(string: item.getAblumUrl()), placeholderImage: UIImage.init(named: "QQListBack"))
                    }
                }
            }
        }
    }
    
    var musicTypeName:String!{
        didSet{
            self.typeNameLB.text = musicTypeName
        }
    }
    
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
        self.iconView = UIImageView.init(frame: CGRect.init(x: 10, y: 0, width: 80, height: 80))
        self.iconView.image = UIImage.init(named: "QQListBack")
        self.addSubview(self.iconView)
        
        self.typeNameLB = UILabel.init(frame: CGRect.init(x: 0, y: 25, width: 80, height: 30))
        self.typeNameLB.textAlignment = NSTextAlignment.center
        self.typeNameLB.backgroundColor = UIColor.clear
        self.typeNameLB.textColor = UIColor.white
        self.typeNameLB.font = UIFont.boldSystemFont(ofSize: 20)
        self.iconView.addSubview(self.typeNameLB)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
