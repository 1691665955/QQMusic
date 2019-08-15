//
//  MusicItem.swift
//  MyFirstSwiftProject
//
//  Created by 曾龙 on 17/3/25.
//  Copyright © 2017年 scinan. All rights reserved.
//

import UIKit
import HandyJSON

class SingerItem: NSObject,HandyJSON,NSCoding {
    
    var picurl:String?
    var name:String!
    var mid:String!
    var id:Int!
    
    required override init() {
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(picurl, forKey: "picurl")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(mid, forKey: "mid")
        aCoder.encode(id, forKey: "id")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        picurl = (aDecoder.decodeObject(forKey: "picurl") as? String)
        name = (aDecoder.decodeObject(forKey: "name") as! String)
        mid = (aDecoder.decodeObject(forKey: "mid") as! String)
        id = (aDecoder.decodeObject(forKey: "id") as! Int)
    }
}

class AlbumItem: NSObject,HandyJSON,NSCoding {
    var mid:String!
    var name:String!
    
    required override init() {
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(mid, forKey: "mid")
        aCoder.encode(mid, forKey: "name")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        mid = (aDecoder.decodeObject(forKey: "mid") as! String)
        name = (aDecoder.decodeObject(forKey: "name") as! String)
    }
}

@objc class MusicItem:NSObject,HandyJSON,NSCoding{
    required override init() {
        
    }
    
    var musicLyricTimes:NSMutableArray?
    var musicLyricLyrics:NSMutableArray?
    
    var singer:[SingerItem]!
    var title:String!
    var mid:String!
    var album:AlbumItem!
    var mv:MVItem!
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(musicLyricTimes, forKey: "musicLyricTimes")
        aCoder.encode(musicLyricLyrics, forKey: "musicLyricLyrics")
        aCoder.encode(singer, forKey: "singer")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(mid, forKey: "mid")
        aCoder.encode(album, forKey: "album")
        aCoder.encode(mv, forKey: "mv")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        musicLyricTimes = (aDecoder.decodeObject(forKey: "musicLyricTimes") as? NSMutableArray)
        musicLyricLyrics = (aDecoder.decodeObject(forKey: "musicLyricLyrics") as? NSMutableArray)
        singer = (aDecoder.decodeObject(forKey: "singer") as! [SingerItem])
        title = (aDecoder.decodeObject(forKey: "title") as! String)
        mid = (aDecoder.decodeObject(forKey: "mid") as! String)
        album = (aDecoder.decodeObject(forKey: "album") as! AlbumItem)
        mv = (aDecoder.decodeObject(forKey: "mv") as! MVItem)
    }
    
    func getSingerName() -> String {
        var singer = String.init();
        for singerItem in self.singer {
            singer.append(singerItem.name);
            singer.append("/")
        }
        singer.removeLast();
        return singer;
    }
    
    func getAblumUrl() -> String {
        return "https://y.gtimg.cn/music/photo_new/T002R300x300M000"+self.album.mid+".jpg?max_age=2592000"
    }
    
    func getUrl() -> String {
        return "https://v1.itooi.cn/tencent/url?id="+self.mid+"&quality=128"
    }
}

