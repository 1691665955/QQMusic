//
//  BannerItem.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/13.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit
import HandyJSON

class JumpItem: NSObject,HandyJSON {
    var url:String!
    required override init() {
        
    }
}

class PicItem: NSObject,HandyJSON {
    var url:String!
    required override init() {
        
    }
}

class BannerItem: NSObject,HandyJSON {
    
    var id:Int!
    var type:Int!
    var jump_info:JumpItem!
    var pic_info:PicItem!
    
    
    required override init() {
        
    }
}
