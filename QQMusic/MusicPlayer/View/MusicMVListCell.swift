//
//  MusicMVListCell.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/17.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit

class MusicMVListCell: UITableViewCell {
    
    var coverView:UIImageView!
    var mvNameLB:UILabel!
    var singerLB:UILabel!
    var rankingLB:UILabel!
    var listenerLB:UILabel!
    var mvItem:MVItem! {
        didSet {
            coverView.sd_setImage(with: URL.init(string: mvItem.picurl!), completed: nil);
            mvNameLB.text = mvItem.title;
            singerLB.text = mvItem.getSingerName();
            listenerLB.text = String(mvItem.playcnt!);
            if (mvItem.playcnt! >= 10000) {
                listenerLB.text = String(format: "%.1f万", CGFloat(mvItem.playcnt!)/10000.0);
            }
            if (mvItem.playcnt! >= 100000000) {
                listenerLB.text = String(format: "%.1f亿", CGFloat(mvItem.playcnt!)/100000000.0);
            }
        }
    }
    
    var artistMVItem:ArtistMVItem! {
        didSet {
            coverView.sd_setImage(with: URL.init(string: artistMVItem.pic!), completed: nil);
            mvNameLB.text = artistMVItem.title;
            singerLB.text = artistMVItem.singer_name;
            listenerLB.text = artistMVItem.listenCount
            if (Int(artistMVItem.listenCount)! >= 10000) {
                listenerLB.text = String(format: "%.1f万", CGFloat(Int(artistMVItem.listenCount)!)/10000.0);
            }
            if (Int(artistMVItem.listenCount)! >= 100000000) {
                listenerLB.text = String(format: "%.1f亿", CGFloat(Int(artistMVItem.listenCount)!)/100000000.0);
            }
        }
    }
    
    var index:Int! {
        didSet {
            rankingLB.text = String(index+1);
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.selectionStyle = .none;
        self.initUI();
    }
    
    func initUI() -> Void {
        let SCALE = (SCREEN_WIDTH-20)/355;
        
        coverView = UIImageView.init(frame: CGRect.init(x: 10, y: 10, width: SCREEN_WIDTH-20, height: (SCREEN_WIDTH-20)/640*360));
        coverView.layer.cornerRadius = 5;
        coverView.layer.masksToBounds = true;
        self.addSubview(coverView);
        
        mvNameLB = UILabel.init(frame: CGRect.init(x: 14, y: 12, width: SCREEN_WIDTH-20-28, height: 25*SCALE));
        mvNameLB.textColor = .white;
        mvNameLB.font = .systemFont(ofSize: 18*SCALE);
        coverView.addSubview(mvNameLB);
        
        singerLB = UILabel.init(frame: CGRect.init(x: 14, y: mvNameLB.frame.maxY+5, width: SCREEN_WIDTH-20-28, height: 16*SCALE));
        singerLB.textColor = .white;
        singerLB.font = .systemFont(ofSize: 12*SCALE);
        coverView.addSubview(singerLB)
        
        rankingLB = UILabel.init(frame: CGRect.init(x: SCREEN_WIDTH-20-100*SCALE-14, y: (SCREEN_WIDTH-20)/640*360-50*SCALE-14, width: 100*SCALE, height: 50*SCALE));
        rankingLB.textColor = .white;
        rankingLB.font = .systemFont(ofSize: 36*SCALE);
        rankingLB.textAlignment = .right;
        coverView.addSubview(rankingLB);
        
        let listenerIcon = UIImageView.init(frame: CGRect.init(x: 14, y: (SCREEN_WIDTH-20)/640*360-20-14, width: 20, height: 20));
        listenerIcon.image = UIImage.init(named: "listen_count");
        coverView.addSubview(listenerIcon);
        
        listenerLB = UILabel.init(frame: CGRect.init(x: 37, y: (SCREEN_WIDTH-20)/640*360-20-14, width: SCREEN_WIDTH-20-40, height: 20));
        listenerLB.textColor = .white;
        listenerLB.font = .systemFont(ofSize: 12);
        coverView.addSubview(listenerLB);
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
