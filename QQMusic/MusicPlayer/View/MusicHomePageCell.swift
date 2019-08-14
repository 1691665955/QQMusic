//
//  MusicHomePageCell.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/13.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit

class MusicHomePageCell: UITableViewCell {
    var categoryNameLB:UILabel!
    var iconViewList:[UIImageView]!
    var nameLBList:[UILabel]!
    var listenCountList:[UILabel]!
    var listenCountView:[UIImageView]!
    var itemTapCallback:((Int)->Void)?
    var list:[AnyObject]!
    var type:Int! {
        didSet {
            switch type {
            case 0:
                self.categoryNameLB.text = "热门歌曲";
                MZMusicAPIRequest.getHotMusicList(id: 26, pageSize: 3, page: 1, format: 1) { (musiclist:[MusicItem]) in
                    self.list = musiclist;
                    for i in 0...2{
                        let musicItem = musiclist[i];
                        let iconView = self.iconViewList[i];
                        iconView.sd_setImage(with: URL.init(string: musicItem.pic), completed: nil);
                        let nameLB = self.nameLBList[i];
                        nameLB.text = musicItem.name + "-" + musicItem.singer;
                        let listenCountLB = self.listenCountList[i];
                        listenCountLB.isHidden = true;
                        let listenIcon = self.listenCountView[i];
                        listenIcon.isHidden = true;
                    }
                }
                break
            case 1:
                self.categoryNameLB.text = "热门歌单";
                MZMusicAPIRequest.getHotSongList(categoryID: 10000000, sortId: 2, pageSize: 3, page: 1) { (songListArray:[SongListItem]) in
                    self.list = songListArray
                    for i in 0...2{
                        let songlist = songListArray[i];
                        let iconView = self.iconViewList[i];
                        iconView.sd_setImage(with: URL.init(string: songlist.imgurl), completed: nil);
                        let nameLB = self.nameLBList[i];
                        nameLB.text = songlist.dissname;
                        let listenCountLB = self.listenCountList[i];
                        listenCountLB.isHidden = false;
                        listenCountLB.text = String(songlist.listennum);
                        let listenIcon = self.listenCountView[i];
                        listenIcon.isHidden = false;
                        if (songlist.listennum >= 10000) {
                            listenCountLB.text = String(format: "%.1f万", CGFloat(songlist.listennum)/10000.0);
                        }
                        if (songlist.listennum >= 100000000) {
                            listenCountLB.text = String(format: "%.1f亿", CGFloat(songlist.listennum)/100000000.0);
                        }
                    }
                }
                break
            case 2:
                self.categoryNameLB.text = "热门MV";
                MZMusicAPIRequest.getHotMVList(order: 1, pageSize: 3, page: 1) { (mvList:[MVItem]) in
                    self.list = mvList
                    for i in 0...2{
                        let mvItem = mvList[i];
                        let iconView = self.iconViewList[i];
                        iconView.sd_setImage(with: URL.init(string: mvItem.picurl), completed: nil);
                        let nameLB = self.nameLBList[i];
                        nameLB.text = mvItem.title;
                        let listenCountLB = self.listenCountList[i];
                        listenCountLB.isHidden = false;
                        listenCountLB.text = String(mvItem.playcnt);
                        let listenIcon = self.listenCountView[i];
                        listenIcon.isHidden = false;
                        if (mvItem.playcnt >= 10000) {
                            listenCountLB.text = String(format: "%.1f万", CGFloat(mvItem.playcnt)/10000.0);
                        }
                        if (mvItem.playcnt >= 100000000) {
                            listenCountLB.text = String(format: "%.1f亿", CGFloat(mvItem.playcnt)/100000000.0);
                        }
                    }
                }
                break
            default:
                break
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.selectionStyle = .none;
        self.setupUI();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() -> Void {
        self.iconViewList = [UIImageView]();
        self.nameLBList = [UILabel]();
        self.listenCountList = [UILabel]();
        self.listenCountView = [UIImageView]();
        
        let SCALE = SCREEN_WIDTH/375;
        let topView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 30));
        topView.isUserInteractionEnabled = true;
        self.addSubview(topView);
        
        let categoryNameLB = UILabel.init(frame: CGRect.init(x: 30*SCALE, y: 0, width: 200, height: 20));
        categoryNameLB.text = "歌单";
        categoryNameLB.font = .systemFont(ofSize: 18);
        topView.addSubview(categoryNameLB);
        self.categoryNameLB = categoryNameLB;
        
        for i in 0...2 {
            let itemView = UIView.init(frame: CGRect.init(x: 30*SCALE+110*SCALE*CGFloat(i), y: 30, width: 95*SCALE, height: 95*SCALE+40));
            itemView.isUserInteractionEnabled = true;
            itemView.tag = 100+i;
            self.addSubview(itemView);
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(itemTap));
            itemView.addGestureRecognizer(tap);
            
            let iconView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 95*SCALE, height: 95*SCALE));
            iconView.backgroundColor = .gray;
            iconView.layer.cornerRadius = 5*SCALE;
            iconView.layer.masksToBounds = true;
            iconView.contentMode = .scaleAspectFill;
            iconView.clipsToBounds = true;
            itemView.addSubview(iconView);
            self.iconViewList.append(iconView);
            
            let listenIconView = UIImageView.init(frame: CGRect.init(x: 5*SCALE, y: 72*SCALE, width: 16*SCALE, height: 16*SCALE));
            listenIconView.image = UIImage.init(named: "listen_count");
            iconView.addSubview(listenIconView);
            self.listenCountView.append(listenIconView)
            
            let listenCountLB = UILabel.init(frame: CGRect.init(x: 24*SCALE, y: 75*SCALE, width: 70*SCALE, height: 10*SCALE));
            listenCountLB.textColor = .white;
            listenCountLB.font = .systemFont(ofSize: 8);
            listenCountLB.text = "12.5万"
            iconView.addSubview(listenCountLB);
            self.listenCountList.append(listenCountLB);
            
            let nameLB = UILabel.init(frame: CGRect.init(x: 0, y: 95*SCALE+5, width: 95*SCALE, height: 40*SCALE));
            nameLB.numberOfLines = 2;
            nameLB.font = .systemFont(ofSize: 12);
            nameLB.text = "是连接啊电视剧啊疯狂的肌肤";
            if i == 0 {
                nameLB.text = "疯狂的肌肤";
            }
            itemView.addSubview(nameLB);
            self.nameLBList.append(nameLB);
        }
    }
    
    @objc func itemTap(tap:UITapGestureRecognizer) -> Void {
        if (self.itemTapCallback != nil) {
            self.itemTapCallback!(tap.view!.tag-100);
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
