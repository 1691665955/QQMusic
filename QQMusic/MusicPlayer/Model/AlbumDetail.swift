//
//  AlbumDetail.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/20.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit
import HandyJSON

class AlbumInfo: NSObject,HandyJSON {
    
    var Falbum_mid:String!
    var Fpublic_time:String!
    var Falbum_name:String!
    
    required override init() {
        
    }
}

class ExtraItem: NSObject,HandyJSON {
    
    var Fupload_time:String!
    
    required override init() {
        
    }
    
    func getTime() -> String {
        let time = self.Fupload_time.components(separatedBy: " ");
        if time.count > 0 {
            return time[0]
        }
        return ""
    }
}

class SongItem: NSObject,HandyJSON {
    
    var singer:[SingerItem]!
    var songmid:String!
    var albumname:String!
    var albummid:String!
    var vid:String!
    var songname:String!
    var interval:Int!
    var extra:ExtraItem!

    required override init() {
        
    }
}

class AlbumDesc: NSObject,HandyJSON {
    var Falbum_desc:String!
    
    required override init() {
        
    }
}


class SingerInfo: NSObject,HandyJSON {
    var Fsinger_name:String!
    
    required override init() {
        
    }
}

class AlbumDetail: NSObject,HandyJSON {
    
    var getAlbumInfo:AlbumInfo!
    var getSongInfo:[SongItem]!
    var albumtype:String!
    var radio_anchor:Int!
    var language:String!
    var getAlbumDesc:AlbumDesc!
    var getSingerInfo:SingerInfo!
    var genre:String!
    
    required override init() {
        
    }
    
    func getAblumUrl() -> String {
        return "https://y.gtimg.cn/music/photo_new/T002R300x300M000"+self.getAlbumInfo.Falbum_mid+".jpg?max_age=2592000"
    }
}
