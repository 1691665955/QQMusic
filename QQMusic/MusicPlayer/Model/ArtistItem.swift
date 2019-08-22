//
//  ArtistItem.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/21.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit
import HandyJSON

class ArtistItem: NSObject,HandyJSON {
    
    var singer_id:Int!
    var country:String!
    var singer_name:String!
    var singer_pic:String!
    var singer_mid:String!
    
    required override init() {
        
    }
    
    func getSmallSingerPic() -> String {
        return self.singer_pic.replacingOccurrences(of: "webp", with: "jpg")
    }
    
    func getLargeSingerPic() -> String {
        return self.singer_pic.replacingOccurrences(of: "webp", with: "jpg").replacingOccurrences(of: "150x150", with: "300x300")
    }
}
