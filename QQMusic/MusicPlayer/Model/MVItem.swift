//
//  MVItem.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/14.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit
import HandyJSON

class MVItem: NSObject,HandyJSON,NSCoding {
    
    var playcnt:Int?
    var diff:Int?
    var title:String?
    var comment_cnt:Int?
    var star_cnt:Int?
    var duration:Int?
    var picurl:String?
    var vid:String?
    var score:Int?
    var has_star:Int?
    var mv_switch:Int?
    var mvid:Int?
    var pubdate:Int?
    
    required override init() {
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(playcnt, forKey: "playcnt")
        aCoder.encode(diff, forKey: "diff")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(comment_cnt, forKey: "comment_cnt")
        aCoder.encode(star_cnt, forKey: "star_cnt")
        aCoder.encode(duration, forKey: "duration")
        aCoder.encode(picurl, forKey: "picurl")
        aCoder.encode(vid, forKey: "vid")
        aCoder.encode(score, forKey: "score")
        aCoder.encode(has_star, forKey: "has_star")
        aCoder.encode(mv_switch, forKey: "mv_switch")
        aCoder.encode(mvid, forKey: "mvid")
        aCoder.encode(pubdate, forKey: "pubdate")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        playcnt = (aDecoder.decodeObject(forKey: "playcnt") as? Int)
        diff = (aDecoder.decodeObject(forKey: "diff") as? Int)
        title = (aDecoder.decodeObject(forKey: "title") as? String)
        comment_cnt = (aDecoder.decodeObject(forKey: "comment_cnt") as? Int)
        star_cnt = (aDecoder.decodeObject(forKey: "star_cnt") as? Int)
        duration = (aDecoder.decodeObject(forKey: "duration") as? Int)
        picurl = (aDecoder.decodeObject(forKey: "picurl") as? String)
        vid = (aDecoder.decodeObject(forKey: "vid") as? String)
        score = (aDecoder.decodeObject(forKey: "score") as? Int)
        has_star = (aDecoder.decodeObject(forKey: "has_star") as? Int)
        mv_switch = (aDecoder.decodeObject(forKey: "mv_switch") as? Int)
        mvid = (aDecoder.decodeObject(forKey: "mvid") as? Int)
        pubdate = (aDecoder.decodeObject(forKey: "pubdate") as? Int)
    }
}
