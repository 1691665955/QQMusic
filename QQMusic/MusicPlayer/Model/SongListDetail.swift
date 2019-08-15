//
//  SongListDetail.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/14.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit
import HandyJSON

class TagItem: NSObject,HandyJSON {
    
    var name:String!
    var pid:Int!
    var id:Int!
    
    required override init() {
        
    }
}

class SongListDetail: NSObject,HandyJSON {
    
    var songnum:Int!
    var nick:String!
    var dissname:String!
    var logo:String!
    var cm_count:Int!
    var headurl:String!
    var disstid:String!
    var ifpicurl:String!
    var visitnum:Int!
    var tags:[TagItem]!
    var songlist:[MusicItem]!
    var desc:String!
    
    required override init() {
        
    }
}
