//
//  SongListCategoryGroupItem.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/16.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit
import HandyJSON

class SongListCategoryItem: NSObject,HandyJSON {
    
    var categoryName:String!
    var categoryId:Int!
    
    required override init() {
        
    }
}

class SongListCategoryGroupItem: NSObject,HandyJSON {
    
    var categoryGroupName:String!
    var items:[SongListCategoryItem]!
    
    required override init() {
        
    }
}
