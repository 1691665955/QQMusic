//
//  MusicSongListIntroduceVC.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/15.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit

class MusicSongListIntroduceVC: UIViewController {

    var model:SongListDetail!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white;
        self.title = "歌单简介";
        
        let bgView = UIImageView.init(frame: CGRect.init(x: 0, y: Navi_Height, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-Navi_Height));
        bgView.sd_setImage(with: URL.init(string: self.model.logo), completed: nil);
        self.view.addSubview(bgView);
        
        //创建背景毛玻璃效果
        let blurEffect  = UIBlurEffect.init(style: UIBlurEffect.Style.light)
        let blurView = UIVisualEffectView.init(effect: blurEffect)
        blurView.frame.size = CGSize.init(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        let vibrancyView = UIVisualEffectView.init(effect: UIVibrancyEffect.init(blurEffect: blurEffect))
        vibrancyView.frame.size = CGSize.init(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        blurView.contentView.addSubview(vibrancyView)
        self.view.addSubview(blurView)
        
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: Navi_Height, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-Navi_Height));
        self.view.addSubview(scrollView);
        
        let SCALE = SCREEN_WIDTH/375;
        
        let logoView = UIImageView.init(frame: CGRect.init(x: 80*SCALE, y: 20*SCALE, width: 215*SCALE, height: 215*SCALE));
        logoView.sd_setImage(with: URL.init(string: self.model.logo), completed: nil);
        scrollView.addSubview(logoView);
        
        let songListNameLB = UILabel.init(frame: CGRect.init(x: 0, y: logoView.frame.maxY+20*SCALE, width: SCREEN_WIDTH, height: 20*SCALE));
        songListNameLB.text = self.model.dissname;
        songListNameLB.textColor = .white;
        songListNameLB.textAlignment = .center;
        songListNameLB.font = .systemFont(ofSize: 16*SCALE);
        scrollView.addSubview(songListNameLB);
        
        let avatar = UIImageView.init(frame: CGRect.init(x: 0, y: songListNameLB.frame.maxY+16*SCALE, width: 20*SCALE, height: 20*SCALE));
        avatar.layer.cornerRadius = 10*SCALE;
        avatar.layer.masksToBounds = true;
        avatar.sd_setImage(with: URL.init(string: self.model.headurl), completed: nil);
        scrollView.addSubview(avatar);
        
        let nickNameLB = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 20*SCALE));
        nickNameLB.textColor = .white;
        nickNameLB.font = .systemFont(ofSize: 12*SCALE);
        nickNameLB.text = self.model.nick;
        let maxSize = CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: 20*SCALE);
        let size = nickNameLB.sizeThatFits(maxSize);
        avatar.frame = CGRect.init(x: (SCREEN_WIDTH-20*SCALE-5*SCALE-size.width)/2, y: songListNameLB.frame.maxY+16*SCALE, width: 20*SCALE, height: 20*SCALE);
        nickNameLB.frame = CGRect.init(x: avatar.frame.maxX+5, y: songListNameLB.frame.maxY+16*SCALE, width: size.width, height: 20*SCALE);
        scrollView.addSubview(nickNameLB);
        
        let itemWidth = 60*SCALE;
        let itemHeight = 30*SCALE;
        let itemMargin = 10*SCALE;
        let originX = (SCREEN_WIDTH-itemWidth*CGFloat(self.model.tags.count)-itemMargin*CGFloat(self.model.tags.count-1))/2;
        
        for (index,tag) in self.model.tags.enumerated() {
            let tagLB = UILabel.init(frame: CGRect.init(x: originX+(itemWidth+itemMargin)*CGFloat(index), y: avatar.frame.maxY+30*SCALE, width: itemWidth, height: itemHeight));
            tagLB.text = tag.name;
            tagLB.textColor = .white;
            tagLB.font = .systemFont(ofSize: 12*SCALE);
            tagLB.textAlignment = .center;
            tagLB.layer.cornerRadius = 15*SCALE;
            tagLB.layer.masksToBounds = true;
            tagLB.layer.borderWidth = 0.5;
            tagLB.layer.borderColor = UIColor.white.cgColor;
            scrollView.addSubview(tagLB);
        }
        
        let descLB = UILabel.init(frame: CGRect.init(x: 14*SCALE, y: avatar.frame.maxY+80*SCALE, width: SCREEN_WIDTH-28*SCALE, height: 100));
        descLB.textColor = .white;
        descLB.font = .systemFont(ofSize: 12*SCALE);
        descLB.numberOfLines = 0;
        descLB.text = self.model.desc.htmlText();
        let maxSize1 = CGSize.init(width: SCREEN_WIDTH-28*SCALE, height: CGFloat.greatestFiniteMagnitude);
        let size1 = descLB.sizeThatFits(maxSize1);
        var frame = descLB.frame;
        frame.size.height = size1.height;
        descLB.frame = frame;
        scrollView.addSubview(descLB);
        
        scrollView.contentSize = CGSize.init(width: 0, height: descLB.frame.maxY+20*SCALE);
    }
}
