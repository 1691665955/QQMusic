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
    var songid:String!
    var albumpic_big:String!
    var singerid:String?
    var downUrl:String!
    var url:String?
    var singername:String!
    var albumpic_small:String?
    var songname:String!
    var m4a:String?{
        didSet{
            if m4a != nil {
                self.url = m4a
            }
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(musicLyricTimes, forKey: "musicLyricTimes")
        aCoder.encode(musicLyricLyrics, forKey: "musicLyricLyrics")
        aCoder.encode(songid, forKey: "songid")
        aCoder.encode(albumpic_big, forKey: "albumpic_big")
        aCoder.encode(downUrl, forKey: "downUrl")
        aCoder.encode(singerid, forKey: "singerid")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(singername, forKey: "singername")
        aCoder.encode(albumpic_small, forKey: "albumpic_small")
        aCoder.encode(songname, forKey: "songname")
        aCoder.encode(m4a, forKey: "m4a")
    }
    
    required init?(coder aDecoder: NSCoder) {
        musicLyricTimes = aDecoder.decodeObject(forKey: "musicLyricTimes") as? NSMutableArray
        musicLyricLyrics = aDecoder.decodeObject(forKey: "musicLyricLyrics") as? NSMutableArray
        songid = (aDecoder.decodeObject(forKey: "songid") as! String)
        albumpic_big = (aDecoder.decodeObject(forKey: "albumpic_big") as! String)
        downUrl = (aDecoder.decodeObject(forKey: "downUrl") as! String)
        singerid = aDecoder.decodeObject(forKey: "singerid") as? String
        url = aDecoder.decodeObject(forKey: "url") as? String
        singername = (aDecoder.decodeObject(forKey: "singername") as! String)
        albumpic_small = aDecoder.decodeObject(forKey: "albumpic_small") as? String
        songname = (aDecoder.decodeObject(forKey: "songname") as! String)
        m4a = aDecoder.decodeObject(forKey: "m4a") as? String
    }
}

