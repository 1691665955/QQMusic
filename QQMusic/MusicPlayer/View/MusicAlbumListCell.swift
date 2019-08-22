//
//  MusicAlbumListCell.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/22.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit

class MusicAlbumListCell: UITableViewCell {
    
    var logoView:UIImageView!
    var nameLB:UILabel!
    var publishTimeLB:UILabel!
    var songcountLB:UILabel!
    var albumItem:ArtistAlbumItem! {
        didSet {
            logoView.sd_setImage(with: URL.init(string: albumItem.getAblumUrl()), completed: nil);
            nameLB.text = albumItem.album_name;
            publishTimeLB.text = albumItem.pub_time;
            songcountLB.text = String(albumItem.latest_song.song_count)+"首"
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.selectionStyle = .none;
        self.initUI()
    }
    
    func initUI() -> Void {
        logoView = UIImageView.init(frame: CGRect.init(x: 15, y: 10, width: 60, height: 60));
        logoView.layer.cornerRadius = 5;
        logoView.layer.masksToBounds = true;
        self.addSubview(logoView);
        
        nameLB = UILabel.init(frame: CGRect.init(x: 85, y: 15, width: SCREEN_WIDTH-120, height: 25));
        nameLB.font = .systemFont(ofSize: 16);
        self.addSubview(nameLB);
        
        publishTimeLB = UILabel.init(frame: CGRect.init(x: 85, y: 40, width: 80, height: 25));
        publishTimeLB.textColor = RGB(r: 136, g: 136, b: 136);
        publishTimeLB.font = .systemFont(ofSize: 12);
        self.addSubview(publishTimeLB)
        
        songcountLB = UILabel.init(frame: CGRect.init(x: 170, y: 40, width: SCREEN_WIDTH-200, height: 25));
        songcountLB.textColor = RGB(r: 136, g: 136, b: 136);
        songcountLB.font = .systemFont(ofSize: 12);
        self.addSubview(songcountLB)
        
        let arrow = UIImageView.init(frame: CGRect.init(x: SCREEN_WIDTH-30, y: 35, width: 10, height: 10));
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
