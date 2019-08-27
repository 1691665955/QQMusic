//
//  SearchMVItem.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/23.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit
import HandyJSON

class SearchMVItem: NSObject,HandyJSON {
    
    var mv_name:String!
    var play_count:Int!
    var singer_name:String!
    var mv_pic_url:String!
    var v_id:String!
    var duration:Int!
    
    required override init() {
        
    }
}
