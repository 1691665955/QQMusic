//
//  MusicRankingCategoryOtherCell.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/16.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit

class MusicRankingCategoryOtherCell: UITableViewCell {
    
    var type:Int! {
        didSet {
            if self.subviews.count == 9 && type == 3 {
                return;
            }
            if self.subviews.count == 6 && type != 3 {
                return;
            }
            self.initUI(type: type)
        }
    }
    
    var tapRanking:((String,Int)->Void)!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.selectionStyle = .none;
    }
    
    func initUI(type:Int) -> Void {
        for (_,view) in self.subviews.enumerated() {
            view.removeFromSuperview();
        }
        var titles = ["内地榜","香港地区榜","台湾地区榜","欧美榜","韩国榜","日本榜"];
        var ids = [5,59,61,3,16,17];
        if type == 2 {
            titles = ["抖音排行榜","网络歌曲榜","电音榜","影视金曲榜","腾讯音乐人","说唱榜"];
            ids = [60,28,57,29,52,58];
        } else if type == 3 {
            titles = ["美国公告榜","美国iTunes榜","韩国Mnet榜","英国UK榜","日本公信榜","香港商台榜","JOOX本地热歌榜","台湾KKBOX榜","YouTube音乐榜"];
            ids = [108,123,106,107,105,114,126,127,128];
        }
        
        let itemWidth = (SCREEN_WIDTH-24-20)/3
        let itemHeight = (SCREEN_WIDTH-24-20)/3
        
        for i in 0..<titles.count {
            let bgView = UIView.init(frame: CGRect.init(x: 12+(itemWidth+10)*CGFloat(i%3), y: (itemHeight+10)*CGFloat(i/3), width: itemWidth, height: itemHeight));
            bgView.isUserInteractionEnabled = true;
            bgView.tag = 100+i;
            bgView.layer.cornerRadius = 5;
            bgView.layer.masksToBounds = true;
            self.addSubview(bgView);
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapItem));
            bgView.addGestureRecognizer(tap);
            
            let iconView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: itemWidth, height: itemHeight));
            bgView.addSubview(iconView);
            
            let grayView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: itemWidth, height: itemHeight));
            grayView.backgroundColor = RGBA(r: 136, g: 136, b: 136, a: 0.5);
            bgView.addSubview(grayView);
            
            let titleLB = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: itemWidth, height: itemHeight));
            titleLB.textAlignment = .center;
            titleLB.textColor = .white;
            titleLB.font = .systemFont(ofSize: 10);
            titleLB.text = titles[i];
            bgView.addSubview(titleLB);
            
            MZMusicAPIRequest.getHotMusicList(id: ids[i], pageSize: 1, page: 0, format: 0) { (musicList) in
                if musicList.count > 0 {
                    let musicItem = musicList[0];
                    iconView.sd_setImage(with: URL.init(string: musicItem.getAblumUrl()), completed: nil);
                }
            }
        }
    }
    
    @objc func tapItem(tap:UITapGestureRecognizer) -> Void {
        var titles = ["内地榜","香港地区榜","台湾地区榜","欧美榜","韩国榜","日本榜"];
        var ids = [5,59,61,3,16,17];
        if type == 2 {
            titles = ["抖音排行榜","网络歌曲榜","电音榜","影视金曲榜","腾讯音乐人","说唱榜"];
            ids = [60,28,57,29,52,58];
        } else if type == 3 {
            titles = ["美国公告榜","美国iTunes榜","韩国Mnet榜","英国UK榜","日本公信榜","香港商台榜","JOOX本地热歌榜","台湾KKBOX榜","YouTube"];
            ids = [108,123,106,107,105,114,126,127,128];
        }
        if self.tapRanking != nil {
            self.tapRanking(titles[tap.view!.tag-100],ids[tap.view!.tag-100]);
        }
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
