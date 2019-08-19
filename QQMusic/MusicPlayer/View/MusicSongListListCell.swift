//
//  MusicSongListListCell.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/17.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit

class MusicSongListListCell: UICollectionViewCell {
    
    var logoView:UIImageView!
    var nameLB:UILabel!
    var listenCountLB:UILabel!
    var model:SongListItem! {
        didSet {
            self.logoView.sd_setImage(with: URL.init(string: model.imgurl), completed: nil);
            self.nameLB.text = model.dissname;
            self.listenCountLB.text = String(model.listennum);
            if (model.listennum >= 10000) {
                self.listenCountLB.text = String(format: "%.1f万", CGFloat(model.listennum)/10000.0);
            }
            if (model.listennum >= 100000000) {
                self.listenCountLB.text = String(format: "%.1f亿", CGFloat(model.listennum)/100000000.0);
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.initUI();
    }
    
    func initUI() -> Void {
        logoView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: (SCREEN_WIDTH-36)/2, height: (SCREEN_WIDTH-36)/2));
        logoView.layer.cornerRadius = 5;
        logoView.layer.masksToBounds = true;
        self.addSubview(logoView);
        
        nameLB = UILabel.init(frame: CGRect.init(x: 0, y: (SCREEN_WIDTH-36)/2, width: (SCREEN_WIDTH-36)/2, height: 40));
        nameLB.numberOfLines = 2;
        nameLB.font = .systemFont(ofSize: 12*SCREEN_WIDTH/375);
        self.addSubview(nameLB);
        
        let iconView = UIImageView.init(frame: CGRect.init(x: 5, y: (SCREEN_WIDTH-36)/2-25, width: 20, height: 20));
        iconView.image = UIImage.init(named: "listen_count");
        logoView.addSubview(iconView);
        
        listenCountLB = UILabel.init(frame: CGRect.init(x: 28, y: (SCREEN_WIDTH-36)/2-25, width: (SCREEN_WIDTH-36)/2-30, height: 20));
        listenCountLB.textColor = .white;
        listenCountLB.font = .systemFont(ofSize: 10);
        logoView.addSubview(listenCountLB);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
