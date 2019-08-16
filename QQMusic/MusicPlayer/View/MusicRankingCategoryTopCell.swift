//
//  MusicRankingCategoryTopCell.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/16.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit

class MusicRankingCategoryTopCell: UITableViewCell {
    
    var categoryNameLB:UILabel!
    var musicNameLBList:[UILabel]!
    var logoView:UIImageView!
    var updateLB:UILabel!
    var type:Int! {
        didSet {
            if self.logoView != nil && self.logoView.image != nil  {
                return;
            }
            let idList = [4,26,27]
            let nameList = ["流行指数榜","热歌榜","新歌榜"]
            let updateTimeList = ["每日更新","每周更新","每小时更新"]
            categoryNameLB.text = nameList[type]
            updateLB.text = updateTimeList[type]
            MZMusicAPIRequest.getHotMusicList(id: idList[type], pageSize: 3, page: 0, format: 0) { (musicList) in
                if (musicList.count > 0) {
                    for (index,musicItem) in musicList.enumerated() {
                        let musicNameLB = self.musicNameLBList[index]
                        let text = NSMutableAttributedString.init(string: String.init(format: "%ld.%@ - %@", index+1,musicItem.title,musicItem.getSingerName()));
                        text.setAttributes([NSAttributedString.Key.foregroundColor:RGB(r: 136, g: 136, b: 136)], range: NSRange.init(location: 2+musicItem.title.count, length: 3+musicItem.getSingerName().count));
                        musicNameLB.attributedText = text;
                        if index == 0 {
                            self.logoView.sd_setImage(with: URL.init(string: musicItem.getAblumUrl()), completed: nil);
                        }
                    }
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.selectionStyle = .none;
        self.initUI();
    }
    
    func initUI() -> Void {
        self.backgroundColor = .clear;
        let bgView = UIView.init(frame: CGRect.init(x: 12, y: 0, width: SCREEN_WIDTH-24, height: 90));
        bgView.layer.cornerRadius = 5;
        bgView.layer.masksToBounds = true;
        bgView.backgroundColor = .white;
        self.addSubview(bgView);
        
        categoryNameLB = UILabel.init(frame: CGRect.init(x: 10, y: 10, width: SCREEN_WIDTH-24-20-90, height: 20));
        categoryNameLB.font = .systemFont(ofSize: 16);
        bgView.addSubview(categoryNameLB);
        
        let musicNameLB1 = UILabel.init(frame: CGRect.init(x: 10, y: 30, width: SCREEN_WIDTH-24-20-90, height: 16));
        musicNameLB1.font = .systemFont(ofSize: 12);
        bgView.addSubview(musicNameLB1);
        
        let musicNameLB2 = UILabel.init(frame: CGRect.init(x: 10, y: 46, width: SCREEN_WIDTH-24-20-90, height: 16));
        musicNameLB2.font = .systemFont(ofSize: 12);
        bgView.addSubview(musicNameLB2);
        
        let musicNameLB3 = UILabel.init(frame: CGRect.init(x: 10, y: 62, width: SCREEN_WIDTH-24-20-90, height: 16));
        musicNameLB3.font = .systemFont(ofSize: 12);
        bgView.addSubview(musicNameLB3);
        
        musicNameLBList = [musicNameLB1,musicNameLB2,musicNameLB3]
        
        logoView = UIImageView.init(frame: CGRect.init(x: SCREEN_WIDTH-24-90, y: 0, width: 90, height: 90));
        bgView.addSubview(logoView);
        
        updateLB = UILabel.init(frame: CGRect.init(x: 0, y: 5, width: 85, height: 16));
        updateLB.textColor = .white;
        updateLB.font = .systemFont(ofSize: 8);
        updateLB.textAlignment = .right;
        logoView.addSubview(updateLB);
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

    }

}
