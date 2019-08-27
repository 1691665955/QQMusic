//
//  MusicSearchMVCell.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/23.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit

class MusicSearchMVCell: UITableViewCell {

    var logoView:UIImageView!
    var playAvatar:UIImageView!
    var playCountLB:UILabel!
    var mvNameLB:UILabel!
    var singerLB:UILabel!
    var mvDurationLB:UILabel!
    var mvItem:SearchMVItem! {
        didSet {
            logoView.sd_setImage(with: URL.init(string: mvItem.mv_pic_url), completed: nil);
            playCountLB.text = String(mvItem.play_count);
            if mvItem.play_count >= 10000 {
                playCountLB.text = String.init(format: "%.1lf万", CGFloat(mvItem.play_count)/10000.0);
            } else if mvItem.play_count >= 100000000 {
                playCountLB.text = String.init(format: "%.1lf亿", CGFloat(mvItem.play_count)/100000000.0);
            }
            let maxSize1 = CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: 10);
            let size1 = playCountLB.sizeThatFits(maxSize1);
            playCountLB.frame = CGRect.init(x: 128-5-size1.width, y: 56, width: size1.width, height: 10);
            playAvatar.frame = CGRect.init(x: playCountLB.frame.minX-2-10, y: 56, width: 10, height: 10);
            
            mvNameLB.text = mvItem.mv_name;
            
            singerLB.text = mvItem.singer_name;
            let maxSize2 = CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: 16);
            var size2 = singerLB.sizeThatFits(maxSize2);
            if size2.width > SCREEN_WIDTH-165-40-10 {
                size2.width = SCREEN_WIDTH-165-40-10
            }
            singerLB.frame = CGRect.init(x: 165, y: 60, width: size2.width, height: 16);
            mvDurationLB.frame = CGRect.init(x: singerLB.frame.maxX, y: 60, width: 40, height: 16);
            mvDurationLB.text = String.init(format: "%02ld:%02ld", mvItem.duration/60,mvItem.duration%60);
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none;
        self.initUI()
    }
    
    func initUI() -> Void {
        logoView = UIImageView.init(frame: CGRect.init(x: 10, y: 10, width: 128, height: 72));
        logoView.layer.cornerRadius = 5;
        logoView.layer.masksToBounds = true;
        self.addSubview(logoView);
        
        playAvatar = UIImageView.init(frame: CGRect.init(x: 0, y: 56, width: 10, height: 10));
        playAvatar.image = UIImage.init(named: "video");
        logoView.addSubview(playAvatar);
        
        playCountLB = UILabel.init(frame: CGRect.init(x: 0, y: 56, width: 100, height: 10));
        playCountLB.textColor = .white;
        playCountLB.font = .systemFont(ofSize: 8);
        logoView.addSubview(playCountLB);
        
        mvNameLB = UILabel.init(frame: CGRect.init(x: 145, y: 10, width: SCREEN_WIDTH-155, height: 50));
        mvNameLB.numberOfLines = 0;
        mvNameLB.font = .systemFont(ofSize: 14);
        self.addSubview(mvNameLB)
        
        let tipLB = UILabel.init(frame: CGRect.init(x: 145, y: 63, width: 16, height: 10));
        tipLB.layer.cornerRadius = 2
        tipLB.layer.masksToBounds = true;
        tipLB.layer.borderColor = MainColor.cgColor;
        tipLB.layer.borderWidth = 1;
        tipLB.text = "MV";
        tipLB.textAlignment = .center;
        tipLB.textColor = MainColor;
        tipLB.font = .boldSystemFont(ofSize: 6);
        self.addSubview(tipLB);
        
        singerLB = UILabel.init(frame: CGRect.init(x: 165, y: 60, width: 100, height: 16));
        singerLB.textColor = RGB(r: 136, g: 136, b: 136);
        singerLB.font = .systemFont(ofSize: 12);
        self.addSubview(singerLB);
        
        mvDurationLB = UILabel.init(frame: CGRect.init(x: 165, y: 60, width: 40, height: 16));
        mvDurationLB.textAlignment = .center;
        mvDurationLB.textColor = RGB(r: 136, g: 136, b: 136);
        mvDurationLB.font = .systemFont(ofSize: 12);
        self.addSubview(mvDurationLB);
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
