//
//  MusicSearchAlbumCell.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/23.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit

class MusicSearchAlbumCell: UITableViewCell {

    var logoView:UIImageView!
    var nameLB:UILabel!
    var singerLB:UILabel!
    var albumItem:SearchAlbumItem! {
        didSet {
            logoView.sd_setImage(with: URL.init(string: albumItem.albumPic), completed: nil);
            nameLB.text = albumItem.albumName;
            singerLB.text = albumItem.singerName_hilight.htmlText()+"   "+albumItem.publicTime
        }
    }
    var songListItem:SongListItem! {
        didSet {
            logoView.sd_setImage(with: URL.init(string: songListItem.imgurl), completed: nil);
            nameLB.text = songListItem.dissname.htmlText();
            var count = String.init(format: "%ld", songListItem.listennum);
            if songListItem.listennum >= 10000 {
                count = String.init(format: "%.1lf万", CGFloat(songListItem.listennum)/10000.0);
            } else if songListItem.listennum >= 100000000 {
                count = String.init(format: "%.1lf亿", CGFloat(songListItem.listennum)/100000000.0);
            }
            singerLB.text = String.init(format: "%ld首   %@人播放   %@", songListItem.song_count,count,songListItem.creator.name.htmlText())
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
        
        singerLB = UILabel.init(frame: CGRect.init(x: 85, y: 40, width: SCREEN_WIDTH-120, height: 25));
        singerLB.textColor = RGB(r: 136, g: 136, b: 136);
        singerLB.font = .systemFont(ofSize: 12);
        self.addSubview(singerLB)
        
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
