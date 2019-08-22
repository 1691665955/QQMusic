//
//  SingerCategory.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/21.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit
import HandyJSON

class SingerCategoryItem: NSObject,HandyJSON {
    
    var name:String!
    var id:Int!
    
    required override init() {
        
    }
}

class SingerCategory: NSObject,HandyJSON {
    
    var area:[SingerCategoryItem]!
    var sex:[SingerCategoryItem]!
    var genre:[SingerCategoryItem]!
    var index:[SingerCategoryItem]!
    
    required override init() {
        
    }
}
