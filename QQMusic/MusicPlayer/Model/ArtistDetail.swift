//
//  ArtistDetail.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/21.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit
import HandyJSON

class ArtistInfo: NSObject,HandyJSON {
    
    var name:String!
    var mid:String!
    var fans:Int!
    
    required override init() {
        
    }
}

class ArtistDetail: NSObject,HandyJSON {
    
    var singer_brief:String!
    var singer_info:ArtistInfo!
    
    required override init() {
        
    }
}
