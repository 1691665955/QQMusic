//
//  MusicItem.swift
//  MyFirstSwiftProject
//
//  Created by 曾龙 on 17/3/25.
//  Copyright © 2017年 scinan. All rights reserved.
//

import UIKit
import HandyJSON

@objc class MusicItem:NSObject,HandyJSON,NSCoding{
    required override init() {
        
    }
    
    var musicLyricTimes:NSMutableArray?
    var musicLyricLyrics:NSMutableArray?
    
    var singer:String!
    var name:String!
    var id:String!
    var time:Int!
    var pic:String!
    var lrc:String!
    var url:String!
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(musicLyricTimes, forKey: "musicLyricTimes")
        aCoder.encode(musicLyricLyrics, forKey: "musicLyricLyrics")
        aCoder.encode(singer, forKey: "singer")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(time, forKey: "time")
        aCoder.encode(pic, forKey: "pic")
        aCoder.encode(lrc, forKey: "lrc")
        aCoder.encode(url, forKey: "url")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        musicLyricTimes = aDecoder.decodeObject(forKey: "musicLyricTimes") as? NSMutableArray
        musicLyricLyrics = aDecoder.decodeObject(forKey: "musicLyricLyrics") as? NSMutableArray
        singer = (aDecoder.decodeObject(forKey: "singer") as! String)
        name = (aDecoder.decodeObject(forKey: "name") as! String)
        id = (aDecoder.decodeObject(forKey: "id") as! String)
        time = aDecoder.decodeObject(forKey: "time") as? Int
        pic = aDecoder.decodeObject(forKey: "pic") as? String
        lrc = (aDecoder.decodeObject(forKey: "lrc") as! String)
        url = aDecoder.decodeObject(forKey: "url") as? String
    }
}

