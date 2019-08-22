//
//  MusicSingerListCell.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/21.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit

class MusicSingerListCell: UITableViewCell {

    var iconView:UIImageView!
    var singerNameLB:UILabel!
    var artist:ArtistItem! {
        didSet {
            iconView.sd_setImage(with: URL.init(string: artist.getSmallSingerPic()), completed: nil);
            singerNameLB.text = artist.singer_name
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.selectionStyle = .none;
        self.initUI()
    }
    
    func initUI() -> Void {
        self.backgroundColor = .clear;
        
        iconView = UIImageView.init(frame: CGRect.init(x: 15, y: 5, width: 60, height: 60));
        iconView.layer.cornerRadius = 30;
        iconView.layer.masksToBounds = true;
        self.addSubview(iconView);
        
        singerNameLB = UILabel.init(frame: CGRect.init(x: 85, y: 0, width: SCREEN_WIDTH-125, height: 70));
        singerNameLB.font = .systemFont(ofSize: 14);
        self.addSubview(singerNameLB);
        
        let arrow = UIImageView.init(frame: CGRect.init(x: SCREEN_WIDTH-30, y: 30, width: 10, height: 10));
        arrow.image = UIImage.init(named: "arrow_gray");
        self.addSubview(arrow);
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
