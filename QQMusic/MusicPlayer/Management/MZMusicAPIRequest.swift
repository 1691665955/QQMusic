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
    
    //showAPI申请的appId
    private let appId:String!
    //showAPI申请的secret
    private let secret:String!
    //接口地址
    private let url:String
    
    //请求实例，持有以实现取消操作
    private var request:Request!
    
    //构造方法
    @objc init(url:String,appId:String,secret:String){
        self.appId=appId
        self.secret=secret
        self.url=url
    }
    
    func post(parameters:[String:Any]?,callback:@escaping (NSDictionary)->Void) {
        if parameters != nil {
            Alamofire.request(self.url, parameters: self.createSecretParam(parameters: parameters))
                .responseJSON { response in
                    self.response(response: response, callback: callback)
            }
        }
    }
    
    private func createSecretParam(parameters:[String:Any]?) -> [String:Any] {
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyyMMddHHmmss"
        var re:[String:Any] = ["showapi_appid":self.appId!,
                               "showapi_timestamp":formatter.string(from: Date.init()),
                               "showapi_sign":self.secret!
        ]
        if parameters != nil {
            for (key,value) in parameters! {
                re[key] = value
            }
        }
        return re
    }
    
    private func response(response:DataResponse<Any>,callback:(NSDictionary)->Void){
        if(response.result.isSuccess){
            callback(response.result.value as! NSDictionary)
            
        }else{
            MBProgressHUD.showError(error: "网络异常");
            self.error(error: response.result.error.debugDescription,callback:callback)
        }
    }
    
    private func error(error:String?=nil,callback:(NSDictionary)->Void){
        let re:NSDictionary=["showapi_res_code":-1,"showapi_res_error":error!]
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
    
    
    //根据地区请求热门音乐
    class func getHotMusicList(type:String,callback:@escaping ([MusicItem])->Void) {
        //数据请求
        let ApiRequest = MZMusicAPIRequest.init(url: "http://route.showapi.com/213-4", appId: "34762", secret: "c416cc2e238c41ab982bd9719fa0f420")
        ApiRequest.post(parameters: ["topid":type]) { (dic:NSDictionary) in
            if((dic.value(forKey: "showapi_res_code") as! Int) < 0) {
                callback([])
                return
            }
            let dic1:NSDictionary = dic.value(forKey: "showapi_res_body") as! NSDictionary
            let dic2:NSDictionary = dic1.value(forKey: "pagebean") as! NSDictionary
            let musicList:NSArray = dic2.value(forKey: "songlist") as! NSArray
            let musicArr = [MusicItem].deserialize(from: musicList)
            callback(musicArr! as! [MusicItem])
        }
    }
    
    //根据歌曲id查询歌词
   class func getMusicLyric(musicID:String,callback:@escaping (String)->Void) {
        let ApiRequest = MZMusicAPIRequest.init(url: "http://route.showapi.com/213-2", appId: "34762", secret: "c416cc2e238c41ab982bd9719fa0f420")
        ApiRequest.post(parameters: ["musicid":musicID]) { (dic:NSDictionary) in
            if((dic.value(forKey: "showapi_res_code") as! Int) < 0) {
                callback("")
                return
            }
            let dic1:NSDictionary = dic.value(forKey: "showapi_res_body") as! NSDictionary
            var lyric:String? = dic1.value(forKey: "lyric") as? String
            if(lyric == nil) {
                lyric = ""
            }
            callback(lyric!)
        }
    }
    
    //根据歌名，人名查询歌曲
    class func searchMusicList(keyword:String,page:Int,callback:@escaping ([MusicItem])->Void) {
        //数据请求
        let ApiRequest = MZMusicAPIRequest.init(url: "http://route.showapi.com/213-1", appId: "34762", secret: "c416cc2e238c41ab982bd9719fa0f420")
        ApiRequest.post(parameters: ["keyword":keyword,"page":"\(page)"]) { (dic:NSDictionary) in
            if((dic.value(forKey: "showapi_res_code") as! Int) < 0) {
                callback([])
                return
            }
            let dic1:NSDictionary = dic.value(forKey: "showapi_res_body") as! NSDictionary
            let dic2:NSDictionary = dic1.value(forKey: "pagebean") as! NSDictionary
            let musicList:NSArray = dic2.value(forKey: "contentlist") as! NSArray
            let musicArr = [MusicItem].deserialize(from: musicList)
            
            var arr = [MusicItem]()
            for musicItem in musicArr! {
                if !(musicItem!.songname.contains("#") || musicItem!.singername.contains("#")) {
                    arr.append(musicItem!)
                }
            }
            callback(arr)
        }
    }
    
}
