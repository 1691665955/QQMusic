//
//  MusicListCell.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/15.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit

class MusicListCell: UITableViewCell {

    var indexLB:UILabel!
    var nameLB:UILabel!
    var singerLB:UILabel!
    var mvBtn:UIButton!
    var musicItem:MusicItem! {
        didSet {
            self.nameLB.text = musicItem.title;
            self.singerLB.text = musicItem.getSingerName()+" - "+musicItem.album.name;
            if musicItem.mv.vid!.count == 0 {
                self.mvBtn.isHidden = true;
                self.nameLB.frame = CGRect.init(x: 50, y: 10, width: SCREEN_WIDTH-50-40, height: 20);
                self.singerLB.frame = CGRect.init(x: 50, y: 30, width: SCREEN_WIDTH-50-40, height: 16);
            } else {
                self.mvBtn.isHidden = false;
                self.nameLB.frame = CGRect.init(x: 50, y: 10, width: SCREEN_WIDTH-50-80, height: 20);
                self.singerLB.frame = CGRect.init(x: 50, y: 30, width: SCREEN_WIDTH-50-80, height: 16);
            }
        }
    }
    var index:Int! {
        didSet {
            self.indexLB.text = String(index+1);
        }
    }
    var playMVCallback:((String)->Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.selectionStyle = .none;
        self.initUI();
    }
    
    func initUI() -> Void {
        let indexLB = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 56));
        indexLB.textAlignment = .center;
        indexLB.font = .systemFont(ofSize: 18);
        self.addSubview(indexLB);
        self.indexLB = indexLB;
        
        let nameLB = UILabel.init(frame: CGRect.init(x: 50, y: 10, width: SCREEN_WIDTH-50-80, height: 20));
        nameLB.font = .systemFont(ofSize: 16);
        self.addSubview(nameLB);
        self.nameLB = nameLB;
        
        let singerLB = UILabel.init(frame: CGRect.init(x: 50, y: 30, width: SCREEN_WIDTH-50-80, height: 16));
        singerLB.textColor = RGB(r: 136, g: 136, b: 136);
        singerLB.font = .systemFont(ofSize: 12);
        self.addSubview(singerLB);
        self.singerLB = singerLB;
        
        let mvBtn = UIButton.init(type: .custom);
        mvBtn.frame = CGRect.init(x: SCREEN_WIDTH-80, y: 0, width: 40, height: 56);
        mvBtn.setImage(UIImage.init(named: "music_list_mv_play"), for: .normal);
        mvBtn.addTarget(self, action: #selector(playMV), for: .touchUpInside);
        self.addSubview(mvBtn);
        self.mvBtn = mvBtn;
        
        let moreBtn = UIButton.init(type: .custom);
        moreBtn.frame = CGRect.init(x: SCREEN_WIDTH-40, y: 0, width: 40, height: 56);
        moreBtn.setImage(UIImage.init(named: "music_list_more"), for: .normal);
        moreBtn.addTarget(self, action: #selector(more), for: .touchUpInside);
        self.addSubview(moreBtn);
    }
    
    @objc func playMV() -> Void {
        if self.playMVCallback != nil {
            self.playMVCallback!(self.musicItem.mv.vid!)
        }
    }
    
    @objc func more() -> Void {
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if self.isSelected {
            self.indexLB.textColor = MainColor
            self.nameLB.textColor = MainColor
            self.singerLB.textColor = MainColor
        } else {
            self.indexLB.textColor = .black
            self.nameLB.textColor = .black
            self.singerLB.textColor = RGB(r: 136, g: 136, b: 136)
        }
    }

}
