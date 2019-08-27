//
//  MusicSearchLrcCell.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/23.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit

class MusicSearchLrcCell: UITableViewCell {

    var lrcNameLB:UILabel!
    var lrcSingerLB:UILabel!
    var lrcContentLB:UILabel!
    var unFoldView:UIView!
    var unFoldLB:UILabel!
    var unFoldAvatar:UIImageView!
    var unfoldBlock:(()->Void)!
    var Height:CGFloat!
    var lrcItem:SearchLrcItem! {
        didSet {
            lrcNameLB.text = lrcItem.songname;
            lrcSingerLB.text = lrcItem.getSingerName()
            if lrcItem.unFold {
                let str = NSMutableString.init(string: lrcItem.content.htmlText().replacingOccurrences(of: "\\n", with: "\n"));
                if str.hasSuffix("\n") {
                    str.deleteCharacters(in: NSMakeRange(str.length-1, 1));
                }
                lrcContentLB.attributedText = self.getAttributeStringWithString(string: str as String, lineSpace: 8.0);
                unFoldLB.text = "收起歌词";
                unFoldAvatar.image = UIImage.init(named: "lrc_up");
            } else {
                let str = NSMutableString.init(string: lrcItem.lyric.htmlText().replacingOccurrences(of: "\\n", with: "\n"));
                if str.hasSuffix("\n") {
                    str.deleteCharacters(in: NSMakeRange(str.length-1, 1));
                }
                lrcContentLB.attributedText = self.getAttributeStringWithString(string: str as String, lineSpace: 8.0);
                unFoldLB.text = "展开歌词";
                unFoldAvatar.image = UIImage.init(named: "lrc_down");
            }
            
            if lrcItem.unFold {
                lrcContentLB.frame = CGRect.init(x: 15, y: 75, width: SCREEN_WIDTH-55, height: lrcItem.getUnFoldHeight());
                unFoldView.frame = CGRect.init(x: 0, y: lrcContentLB.frame.maxY, width: 50, height: 40);
            } else {
                lrcContentLB.frame = CGRect.init(x: 15, y: 75, width: SCREEN_WIDTH-55, height: lrcItem.getFoldHeight());
                unFoldView.frame = CGRect.init(x: 0, y: lrcContentLB.frame.maxY, width: 50, height: 40);
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none;
        self.initUI()
    }
    
    func initUI() -> Void {
        lrcNameLB = UILabel.init(frame: CGRect.init(x: 15, y: 15, width: SCREEN_WIDTH-55, height: 20));
        lrcNameLB.font = .systemFont(ofSize: 16);
        self.addSubview(lrcNameLB);
        
        lrcSingerLB = UILabel.init(frame: CGRect.init(x: 15, y: 40, width: SCREEN_WIDTH-55, height: 20));
        lrcSingerLB.font = .systemFont(ofSize: 12);
        lrcSingerLB.textColor = RGB(r: 136, g: 136, b: 136);
        self.addSubview(lrcSingerLB);
        
        let moreBtn = UIButton.init(type: .custom);
        moreBtn.frame = CGRect.init(x: SCREEN_WIDTH-40, y: 10, width: 40, height: 55);
        moreBtn.setImage(UIImage.init(named: "music_list_more"), for: .normal);
        moreBtn.addTarget(self, action: #selector(more), for: .touchUpInside);
        self.addSubview(moreBtn);
        
        lrcContentLB = UILabel.init(frame: CGRect.init(x: 15, y: 75, width: SCREEN_WIDTH-55, height: 50));
        lrcContentLB.font = .systemFont(ofSize: 12);
        lrcContentLB.textColor = RGB(r: 136, g: 136, b: 136);
        lrcContentLB.numberOfLines = 0;
        self.addSubview(lrcContentLB);
        
        unFoldView = UIView.init(frame: CGRect.init(x: 0, y: lrcContentLB.frame.maxY, width: 50, height: 40));
        unFoldView.isUserInteractionEnabled = true;
        self.addSubview(unFoldView);
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(unfold));
        unFoldView.addGestureRecognizer(tap);
        
        unFoldLB = UILabel.init(frame: CGRect.init(x: 15, y: 10, width: 50, height: 20))
        unFoldLB.textColor = RGB(r: 136, g: 136, b: 136);
        unFoldLB.font = .systemFont(ofSize: 12)
        unFoldView.addSubview(unFoldLB);
        
        unFoldAvatar = UIImageView.init(frame: CGRect.init(x: 65, y: 12, width: 16, height: 16))
        unFoldView.addSubview(unFoldAvatar);
        
        let lineView = UIView.init(frame: CGRect.init(x: 15, y: 39.5, width: SCREEN_WIDTH-15, height: 0.5));
        lineView.backgroundColor = RGB(r: 223, g: 223, b: 223);
        unFoldView.addSubview(lineView);
    }
    
    @objc func more() -> Void {
        
    }
    
    @objc func unfold() -> Void {
        self.lrcItem.unFold = !self.lrcItem.unFold
        if (self.unfoldBlock != nil) {
            self.unfoldBlock()
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

    func getAttributeStringWithString(string:String,lineSpace:CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString.init(string: string);
        let paragraphStyle = NSMutableParagraphStyle()
        
        //调整行间距
        paragraphStyle.lineSpacing = lineSpace;
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, string.count));
        return attributedString;
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if NSStringFromClass(touch.view!.classForCoder) == "UITableViewCellContentView" {
            return false
        }
        return true
    }
    
}
