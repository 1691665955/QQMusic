//
//  AlbumDetailIntroduceVC.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/20.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit

class AlbumDetailIntroduceVC: UIViewController {

    var albumDetail:AlbumDetail!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white;
        self.title = "专辑简介";
        
        let bgView = UIImageView.init(frame: CGRect.init(x: 0, y: Navi_Height, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-Navi_Height));
        bgView.sd_setImage(with: URL.init(string: self.albumDetail.getAblumUrl()), completed: nil);
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
        logoView.sd_setImage(with: URL.init(string: self.albumDetail.getAblumUrl()), completed: nil);
        scrollView.addSubview(logoView);
        
        let albumNameLB = UILabel.init(frame: CGRect.init(x: 14, y: logoView.frame.maxY+20*SCALE, width: SCREEN_WIDTH-28, height: 20*SCALE));
        albumNameLB.text = "专辑："+self.albumDetail.getAlbumInfo.Falbum_name;
        albumNameLB.textColor = .white;
        albumNameLB.font = .systemFont(ofSize: 12);
        scrollView.addSubview(albumNameLB);
        
        let languageLB = UILabel.init(frame: CGRect.init(x: 14, y: albumNameLB.frame.maxY, width: SCREEN_WIDTH-28, height: 20*SCALE));
        languageLB.text = "语种："+self.albumDetail.language;
        languageLB.textColor = .white;
        languageLB.font = .systemFont(ofSize: 12);
        scrollView.addSubview(languageLB);
        
        let publishLB = UILabel.init(frame: CGRect.init(x: 14, y: languageLB.frame.maxY, width: SCREEN_WIDTH-28, height: 20*SCALE));
        publishLB.text = "发行时间："+self.albumDetail.getAlbumInfo.Fpublic_time;
        publishLB.textColor = .white;
        publishLB.font = .systemFont(ofSize: 12);
        scrollView.addSubview(publishLB);
        
        let albumTypeLB = UILabel.init(frame: CGRect.init(x: 14, y: publishLB.frame.maxY, width: SCREEN_WIDTH-28, height: 20*SCALE));
        albumTypeLB.text = "类型："+self.albumDetail.albumtype;
        albumTypeLB.textColor = .white;
        albumTypeLB.font = .systemFont(ofSize: 12);
        scrollView.addSubview(albumTypeLB);
        
        let genreLB = UILabel.init(frame: CGRect.init(x: 14, y: albumTypeLB.frame.maxY, width: SCREEN_WIDTH-28, height: 20*SCALE));
        genreLB.text = "流派："+self.albumDetail.genre;
        genreLB.textColor = .white;
        genreLB.font = .systemFont(ofSize: 12);
        scrollView.addSubview(genreLB);
    
        
        let descLB = UILabel.init(frame: CGRect.init(x: 14, y: genreLB.frame.maxY+20, width: SCREEN_WIDTH-28, height: 100));
        descLB.textColor = .white;
        descLB.font = .systemFont(ofSize: 12);
        descLB.numberOfLines = 0;
        descLB.text = self.albumDetail.getAlbumDesc.Falbum_desc.htmlText();
        let maxSize1 = CGSize.init(width: SCREEN_WIDTH-28, height: CGFloat.greatestFiniteMagnitude);
        let size1 = descLB.sizeThatFits(maxSize1);
        var frame = descLB.frame;
        frame.size.height = size1.height;
        descLB.frame = frame;
        scrollView.addSubview(descLB);
        
        scrollView.contentSize = CGSize.init(width: 0, height: descLB.frame.maxY+20);
    }

}
