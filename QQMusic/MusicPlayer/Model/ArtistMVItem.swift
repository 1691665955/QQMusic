//
//  ArtistMVItem.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/21.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit
import HandyJSON

class ArtistMVItem: NSObject,HandyJSON {
    
    var singer_name:String!
    var listenCount:String!
    var pic:String!
    var title:String!
    var vid:String!
    
    required override init() {
        
    }
    
    func getPlayUrl() -> String {
        return "https://v1.itooi.cn/tencent/mvUrl?id="+self.vid!+"&quality=1080"
    }
}
