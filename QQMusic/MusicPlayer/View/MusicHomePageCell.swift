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
    var moreTapCallback:(()->Void)?
    var list:[AnyObject]!
    var type:Int! {
        didSet {
            if self.list != nil && self.list.count > 0  {
                return;
            }
            switch type {
            case 0:
                self.categoryNameLB.text = "热门歌曲";
                MZMusicAPIRequest.getHotMusicList(id: 27, pageSize: 3, page: 0, format: 0) { (musiclist:[MusicItem]) in
                    if musiclist.count > 0 {
                        self.list = musiclist;
                        for i in 0...2{
                            let musicItem = musiclist[i];
                            let iconView = self.iconViewList[i];
                            iconView.sd_setImage(with: URL.init(string: musicItem.getAblumUrl()), completed: nil);
                            let nameLB = self.nameLBList[i];
                            nameLB.text = musicItem.title + "-" + musicItem.getSingerName();
                            let listenCountLB = self.listenCountList[i];
                            listenCountLB.isHidden = true;
                            let listenIcon = self.listenCountView[i];
                            listenIcon.isHidden = true;
                        }
                    }
                }
                break
            case 1:
                self.categoryNameLB.text = "热门歌单";
                MZMusicAPIRequest.getHotSongList(categoryID: 10000000, sortId: 1, pageSize: 3, page: 0) { (songListArray:[SongListItem]) in
                    if songListArray.count > 0 {
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
                }
                break
            case 2:
                self.categoryNameLB.text = "热门MV";
                MZMusicAPIRequest.getHotMVList(order: 1, pageSize: 3, page: 0) { (mvList:[MVItem]) in
                    if mvList.count > 0 {
                        self.list = mvList
                        for i in 0...2{
                            let mvItem = mvList[i];
                            let iconView = self.iconViewList[i];
                            iconView.sd_setImage(with: URL.init(string: mvItem.picurl!), completed: nil);
                            let nameLB = self.nameLBList[i];
                            nameLB.text = mvItem.title;
                            let listenCountLB = self.listenCountList[i];
                            listenCountLB.isHidden = false;
                            listenCountLB.text = String(mvItem.playcnt!);
                            let listenIcon = self.listenCountView[i];
                            listenIcon.isHidden = false;
                            if (mvItem.playcnt! >= 10000) {
                                listenCountLB.text = String(format: "%.1f万", CGFloat(mvItem.playcnt!)/10000.0);
                            }
                            if (mvItem.playcnt! >= 100000000) {
                                listenCountLB.text = String(format: "%.1f亿", CGFloat(mvItem.playcnt!)/100000000.0);
                            }
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
        
        let itemWidth = (SCREEN_WIDTH-24-20)/3;
        let itemHeight = (SCREEN_WIDTH-24-20)/3;
        
        let topView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 30));
        topView.isUserInteractionEnabled = true;
        self.addSubview(topView);
        
        let categoryNameLB = UILabel.init(frame: CGRect.init(x: 12, y: 0, width: 200, height: 20));
        categoryNameLB.text = "歌单";
        categoryNameLB.font = .systemFont(ofSize: 18);
        topView.addSubview(categoryNameLB);
        self.categoryNameLB = categoryNameLB;
        
        let moreBtn = UIButton.init(type: .custom);
        moreBtn.frame = CGRect.init(x: SCREEN_WIDTH-12-45, y: 0, width: 45, height: 20);
        moreBtn.setTitle("更多", for: .normal);
        moreBtn.setImage(UIImage.init(named: "arrow_gray"), for: .normal);
        moreBtn.setTitleColor(RGB(r: 136, g: 136, b: 136), for: .normal);
        moreBtn.titleLabel?.font = .systemFont(ofSize: 14);
        moreBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 10);
        moreBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 30, bottom: 0, right: -30);
        moreBtn.addTarget(self, action: #selector(more), for: .touchUpInside);
        topView.addSubview(moreBtn);
        
        for i in 0...2 {
            let itemView = UIView.init(frame: CGRect.init(x: 12+(itemWidth+10)*CGFloat(i), y: 30, width: itemWidth, height: itemHeight+40));
            itemView.isUserInteractionEnabled = true;
            itemView.tag = 100+i;
            self.addSubview(itemView);
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(itemTap));
            itemView.addGestureRecognizer(tap);
            
            let iconView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: itemWidth, height: itemHeight));
            iconView.backgroundColor = .gray;
            iconView.layer.cornerRadius = 5;
            iconView.layer.masksToBounds = true;
            iconView.contentMode = .scaleAspectFill;
            iconView.clipsToBounds = true;
            itemView.addSubview(iconView);
            self.iconViewList.append(iconView);
            
            let listenIconView = UIImageView.init(frame: CGRect.init(x: 5, y: itemHeight-21, width: 16, height: 16));
            listenIconView.image = UIImage.init(named: "listen_count");
            iconView.addSubview(listenIconView);
            self.listenCountView.append(listenIconView)
            
            let listenCountLB = UILabel.init(frame: CGRect.init(x: 24, y: itemHeight-18, width: itemWidth-30, height: 10));
            listenCountLB.textColor = .white;
            listenCountLB.font = .systemFont(ofSize: 8);
            listenCountLB.text = "12.5万"
            iconView.addSubview(listenCountLB);
            self.listenCountList.append(listenCountLB);
            
            let nameLB = UILabel.init(frame: CGRect.init(x: 0, y: itemHeight+5, width: itemWidth, height: 30));
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
    
    @objc func more() -> Void {
        if self.moreTapCallback != nil {
            self.moreTapCallback!()
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
