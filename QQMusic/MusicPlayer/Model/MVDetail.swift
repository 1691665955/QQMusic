//
//  MVDetail.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/19.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit
import HandyJSON

class MVDetail: NSObject,HandyJSON {
    
    var singers:[SingerItem]!
    var playcnt:Int!
    var cover_pic:String!
    var duration:Int!
    var vid:String!
    var name:String!
    var desc:String!
    var pubdate:Int!
    
    required override init() {
        
    }
    
    func getSingerName() -> String {
        var singer = String.init();
        for singerItem in self.singers! {
            singer.append(singerItem.name);
            singer.append("/")
        }
        singer.removeLast();
        return singer;
    }
    
    func getPlayUrl() -> String {
        return "https://v1.itooi.cn/tencent/mvUrl?id="+self.vid!+"&quality=1080"
    }
    
}
