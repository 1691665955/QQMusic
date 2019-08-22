//
//  MusicSingerDescCell.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/22.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit

class MusicSingerDescCell: UITableViewCell {

    var descLB:UILabel!
    var Height:CGFloat!
    var desc:String! {
        didSet {
            descLB.text = desc;
            let maxSize = CGSize.init(width: SCREEN_WIDTH-30, height: CGFloat.greatestFiniteMagnitude);
            let size = descLB.sizeThatFits(maxSize);
            descLB.frame = CGRect.init(x: 15, y: 50, width: SCREEN_WIDTH-30, height: size.height);
            Height = descLB.frame.maxY+10
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.selectionStyle = .none;
        self.initUI()
    }
    
    func initUI() -> Void {
        let tipLB = UILabel.init(frame: CGRect.init(x: 15, y: 15, width: SCREEN_WIDTH-20, height: 20));
        tipLB.text = "歌手简介"
        tipLB.font = .systemFont(ofSize: 16);
        self.addSubview(tipLB);
        
        descLB = UILabel.init(frame: CGRect.init(x: 15, y: 50, width: SCREEN_WIDTH-30, height: 100));
        descLB.numberOfLines = 0;
        descLB.textColor = RGB(r: 136, g: 136, b: 136);
        descLB.font = .systemFont(ofSize: 12);
        self.addSubview(descLB);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
