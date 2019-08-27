//
//  SearchLrcItem.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/23.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit
import HandyJSON

class SearchLrcItem: NSObject,HandyJSON {
    
    var songname:String!
    var songmid:String!
    var albumname:String!
    var singer:[SingerItem]!
    var content:String!
    var lyric:String!
    var unFold = false
    var foldHeight:CGFloat = 0.0
    var unFoldHeight:CGFloat = 0.0
    
    required override init() {
        
    }
    
    func getSingerName() -> String {
        var singer = String.init();
        for singerItem in self.singer! {
            singer.append(singerItem.name);
            singer.append("/")
        }
        singer.removeLast();
        return (singer+" - "+self.albumname).htmlText();
    }
    
    func getFoldHeight() -> CGFloat {
        if foldHeight == 0.0 {
            let str = NSMutableString.init(string: self.lyric.htmlText().replacingOccurrences(of: "\\n", with: "\n"));
            if str.hasSuffix("\n") {
                str.deleteCharacters(in: NSMakeRange(str.length-1, 1));
            }
            let attributedText = self.getAttributeStringWithString(string: str as String, lineSpace: 8.0);
            let size = attributedText.boundingRect(with: CGSize.init(width: SCREEN_WIDTH-55, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).size;
            foldHeight = size.height
        }
        return foldHeight;
    }
    
    func getUnFoldHeight() -> CGFloat {
        if unFoldHeight == 0.0 {
            let str = NSMutableString.init(string: self.content.htmlText().replacingOccurrences(of: "\\n", with: "\n"));
            if str.hasSuffix("\n") {
                str.deleteCharacters(in: NSMakeRange(str.length-1, 1));
            }
            let attributedText = self.getAttributeStringWithString(string: str as String, lineSpace: 8.0);
            let size = attributedText.boundingRect(with: CGSize.init(width: SCREEN_WIDTH-55, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).size;
            unFoldHeight = size.height
        }
        return unFoldHeight;
    }
    
    
    func getAttributeStringWithString(string:String,lineSpace:CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString.init(string: string);
        let paragraphStyle = NSMutableParagraphStyle()
        
        //调整行间距
        paragraphStyle.lineSpacing = lineSpace;
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, string.count));
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 12), range: NSMakeRange(0, string.count))
        return attributedString;
    }
}
