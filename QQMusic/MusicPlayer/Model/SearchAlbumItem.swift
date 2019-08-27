//
//  SearchAlbumItem.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/23.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit
import HandyJSON

class SearchAlbumItem: NSObject,HandyJSON {
    
    var albumName:String!
    var albumMID:String!
    var albumPic:String!
    var singerName:String!
    var publicTime:String!
    var singerName_hilight:String!
    
    required override init() {
        
    }
}
