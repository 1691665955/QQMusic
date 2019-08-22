//
//  ArtistAlbumItem.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/21.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit
import HandyJSON

class ArtistAlbumExtra: NSObject,HandyJSON {
    
    var song_count:Int!
    
    required override init() {
        
    }
}

class ArtistAlbumItem: NSObject,HandyJSON {
    
    var album_name:String!
    var pub_time:String!
    var album_mid:String!
    var latest_song:ArtistAlbumExtra!
    
    required override init() {
        
    }
    
    func getAblumUrl() -> String {
        return "https://y.gtimg.cn/music/photo_new/T002R300x300M000"+self.album_mid+".jpg?max_age=2592000"
    }
}
