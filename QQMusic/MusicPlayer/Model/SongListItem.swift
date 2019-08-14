//
//  SongListItem.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/14.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit
import HandyJSON

class CreatorItem: NSObject,HandyJSON {
    var qq:Int!
    var avatarUrl:String!
    var encrypt_uin:String!
    var name:String!
    var followflag:Int!
    var type:Int!
    var isVip:Int!
    
    required override init() {
        
    }
}

class SongListItem: NSObject,HandyJSON {
    
    var imgurl:String!
    var score:Int!
    var dissid:String!
    var createtime:String!
    var listennum:Int!
    var dissname:String!
    var commit_time:String!
    var version:Int!
    var introduction:String!
    var creator:CreatorItem!
    
    
    required override init() {
        
    }
}
