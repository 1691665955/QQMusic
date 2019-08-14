//
//  MZMusicAPIRequest.swift
//  MyFirstSwiftProject
//
//  Created by 曾龙 on 17/3/31.
//  Copyright © 2017年 scinan. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import CommonCrypto
import HandyJSON

class MZMusicAPIRequest: NSObject {
    
    class func post(url:String!,parameters:[String:Any]?,callback:@escaping (AnyObject)->Void) {
        if parameters != nil {
            if(url.hasPrefix("https://v1.itooi.cn/tencent/lrc")) {
                Alamofire.request(url, parameters: parameters).responseData { (data) in
                    let lyric = String.init(data: data.data ?? Data.init(), encoding: String.Encoding.utf8);
                    print("url:\(url as Any)\nparams:\(parameters as Any)\nlyric:\(String(describing: lyric))");
                    callback(lyric as AnyObject);
                }
            } else {
                Alamofire.request(url, parameters: parameters)
                    .responseJSON { response in
                        print("url:\(url as Any)\nparams:\(parameters as Any)\nresponse:\(response)");
                        self.response(response: response, callback: callback)
                }
            }
        }
    }
    
    class private func response(response:DataResponse<Any>,callback:(NSDictionary)->Void){
        if(response.result.isSuccess){
            callback(response.result.value as! NSDictionary)
        }else{
            MBProgressHUD.showError(error: "网络异常");
            self.error(error: response.result.error.debugDescription,callback:callback)
        }
    }
    
    class private func error(error:String?=nil,callback:(NSDictionary)->Void){
        let re:NSDictionary=["code":-1,"msg":error!]
        callback(re)
    }

    func md5(str:String) -> String {
        let newStr = str.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(str.lengthOfBytes(using: String.Encoding.utf8))
        
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(newStr,strLen,result)
        
        let hash = NSMutableString.init()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        return String(format:hash as String)
    }
    
    
    
    /// 排行榜
    ///
    /// - Parameters:
    ///   - id: 排行榜ID 巅峰榜（4:流行指数榜 26:热歌榜 27:新歌榜）
    ///         地区榜（5:内地榜 59:香港地区榜 61:台湾地区榜 3:欧美榜 16:韩国榜 17:日本榜）
    ///         特色榜（60:抖音排行榜 28:网络歌曲榜 57:电音榜 29:影视金曲榜 52:腾讯音乐人原创榜 36:k歌金曲榜 58:说唱榜）
    ///         全球榜（108:美国公告牌榜 123:美国iTunes榜 106:韩国Mnet榜 107:英国UK榜 105:日本公信榜 114:香港商台榜 126:JOOX本地热播榜 127:台湾KKBOX榜 128:YouTube音乐排行榜）
    ///   - pageSize: 每页显示条数
    ///   - page: 页码
    ///   - format: 格式化数据 1:格式化 0:不格式化
    ///   - callback: 接口回调
    class func getHotMusicList(id:Int,pageSize:Int,page:Int,format:Int,callback:@escaping ([MusicItem])->Void) {
        //数据请求
        self.post(url:"https://v1.itooi.cn/tencent/topList",parameters: ["id":id,"format":format,"pageSize":pageSize,"page":page]) { (dic:AnyObject) in
            if((dic.value(forKey: "code") as! Int) < 0) {
                callback([])
            } else {
                if((dic.value(forKey: "code") as! Int) == 200) {
                    let musicList:NSArray = dic.value(forKey: "data") as! NSArray
                    let musicArr = [MusicItem].deserialize(from: musicList)
                    callback(musicArr! as! [MusicItem])
                } else {
                    MBProgressHUD.showError(error: dic.value(forKey: "msg") as? String)
                    callback([])
                }
            }
        }
    }
    
    
    
   /// 根据歌曲id查询歌词
   ///
   /// - Parameters:
   ///   - id: 歌曲ID
   ///   - callback: 接口回调
   class func getMusicLyric(id:String,callback:@escaping (String)->Void) {
        self.post(url:"https://v1.itooi.cn/tencent/lrc",parameters: ["id":id]) { (string:AnyObject) in
            callback(string as! String)
        }
    }
    
    
    /// 根据歌名，人名查询歌曲
    ///
    /// - Parameters:
    ///   - keyword: g搜索关键字
    ///   - type: 搜索类型
    ///   - pageSize: 每页显示的数量
    ///   - page: 页码
    ///   - format: 格式化数据 1:格式化 0:不格式化
    ///   - callback: 接口回调
    class func searchMusicList(keyword:String,type:String,pageSize:Int,page:Int,format:Int,callback:@escaping ([MusicItem])->Void) {
        self.post(url:"https://v1.itooi.cn/tencent/search",parameters: ["keyword":keyword,"type":type,"pageSize":pageSize,"page":page,"format":format]) { (dic:AnyObject) in
            if((dic.value(forKey: "code") as! Int) < 0) {
                callback([])
                return
            } else {
                if((dic.value(forKey: "code") as! Int) == 200) {
                    let musicList:NSArray = dic.value(forKey: "data") as! NSArray
                    let musicArr = [MusicItem].deserialize(from: musicList)
                    callback(musicArr! as! [MusicItem])
                } else {
                    MBProgressHUD.showError(error: dic.value(forKey: "msg") as? String)
                    callback([])
                }
            }
        }
    }
    
    
    /// 首页广告栏
    ///
    /// - Parameter callback: 接口回调
    class func banner(callback:@escaping ([BannerItem])->Void) {
        self.post(url:"https://v1.itooi.cn/tencent/banner",parameters: [:]) { (dic:AnyObject) in
            if((dic.value(forKey: "code") as! Int) < 0) {
                callback([])
                return
            } else {
                if((dic.value(forKey: "code") as! Int) == 200) {
                    let bannerList:NSArray = dic.value(forKey: "data") as! NSArray
                    let bannerArr = [BannerItem].deserialize(from: bannerList)
                    callback(bannerArr! as! [BannerItem])
                } else {
                    MBProgressHUD.showError(error: dic.value(forKey: "msg") as? String)
                    callback([])
                }
            }
        }
    }
    
    /// 热门歌单
    ///
    /// - Parameters:
    ///   - categoryID: 分类ID
    ///   - sortId: 排序ID
    ///   - pageSize: 每页显示的数量
    ///   - page: 页码
    ///   - callback: 接口回调
    class func getHotSongList(categoryID:Int,sortId:Int,pageSize:Int,page:Int,callback:@escaping ([SongListItem])->Void) {
        self.post(url:"https://v1.itooi.cn/tencent/songList/hot",parameters: ["categoryId":categoryID,"sortId":sortId,"pageSize":pageSize,"page":page]) { (dic:AnyObject) in
            if((dic.value(forKey: "code") as! Int) < 0) {
                callback([])
                return
            } else {
                if((dic.value(forKey: "code") as! Int) == 200) {
                    let data = dic.value(forKey: "data") as! NSDictionary;
                    let songList:NSArray = data.value(forKey: "list") as! NSArray
                    let songListArr = [SongListItem].deserialize(from: songList)
                    callback(songListArr! as! [SongListItem])
                } else {
                    MBProgressHUD.showError(error: dic.value(forKey: "msg") as? String)
                    callback([])
                }
            }
        }
    }
    
    /// 热门 MV
    ///
    /// - Parameters:
    ///   - order: 0:按播放量排序 1:默认排序
    ///   - pageSize: 每页显示的数量
    ///   - page: 页码
    ///   - callback: 接口回调
    class func getHotMVList(order:Int,pageSize:Int,page:Int,callback:@escaping ([MVItem])->Void) {
        self.post(url:"https://v1.itooi.cn/tencent/mv/hot",parameters: ["order":order,"pageSize":pageSize,"page":page]) { (dic:AnyObject) in
            if((dic.value(forKey: "code") as! Int) < 0) {
                callback([])
                return
            } else {
                if((dic.value(forKey: "code") as! Int) == 200) {
                    let data = dic.value(forKey: "data") as! NSDictionary;
                    let mvList:NSArray = data.value(forKey: "list") as! NSArray
                    let mvListArr = [MVItem].deserialize(from: mvList)
                    callback(mvListArr! as! [MVItem])
                } else {
                    MBProgressHUD.showError(error: dic.value(forKey: "msg") as? String)
                    callback([])
                }
            }
        }
    }
    
    class func getSongListDetail(id:String,callback:@escaping ([MusicItem])->Void) {
        self.post(url:"https://v1.itooi.cn/tencent/songList",parameters: ["id":id,"format":1]) { (dic:AnyObject) in
            if((dic.value(forKey: "code") as! Int) < 0) {
                callback([])
            } else {
                if((dic.value(forKey: "code") as! Int) == 200) {
                    let musicList:NSArray = dic.value(forKey: "data") as! NSArray
                    let musicArr = [MusicItem].deserialize(from: musicList)
                    callback(musicArr! as! [MusicItem])
                } else {
                    MBProgressHUD.showError(error: dic.value(forKey: "msg") as? String)
                    callback([])
                }
            }
        }
    }
}
