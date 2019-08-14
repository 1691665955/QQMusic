//
//  MVItem.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/14.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit
import HandyJSON

class SingerItem: NSObject,HandyJSON {
    
    var picurl:String!
    var name:String!
    var mid:String!
    var id:Int!
    
    required override init() {
        
    }
}

class MVItem: NSObject,HandyJSON {
    
    var playcnt:Int!
    var diff:Int!
    var title:String!
    var comment_cnt:Int!
    var star_cnt:Int!
    var duration:Int!
    var picurl:String!
    var vid:String!
    var score:Int!
    var has_star:Int!
    var mv_switch:Int!
    var mvid:Int!
    var pubdate:Int!
    
    required override init() {
        
    }
}
