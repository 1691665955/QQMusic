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
    ///   - keyword: 搜索关键字
    ///   - type: 搜索类型
    ///   - pageSize: 每页显示的数量
    ///   - page: 页码
    ///   - format: 格式化数据 1:格式化 0:不格式化
    ///   - callback: 接口回调
    class func searchMusicList(keyword:String,type:String,pageSize:Int,page:Int,format:Int,callback:@escaping ([Any])->Void) {
        self.post(url:"https://v1.itooi.cn/tencent/search",parameters: ["keyword":keyword,"type":type,"pageSize":pageSize,"page":page,"format":format]) { (dic:AnyObject) in
            if((dic.value(forKey: "code") as! Int) < 0) {
                callback([])
                return
            } else {
                if((dic.value(forKey: "code") as! Int) == 200) {
                    if type == "song" {
                        let data = dic.value(forKey: "data") as! NSDictionary
                        let musicList:NSArray = data.value(forKey: "list") as! NSArray
                        let musicArr = [SongItem].deserialize(from: musicList)
                        callback(MusicItem.convertSongListToMusicList(songList: musicArr! as! [SongItem]))
                    } else if type == "singer" {
                        let data = dic.value(forKey: "data") as! NSDictionary
                        let song = data.value(forKey: "song") as! NSDictionary
                        let musicList:NSArray = song.value(forKey: "list") as! NSArray
                        let musicArr = [SongItem].deserialize(from: musicList)
                        callback(MusicItem.convertSongListToMusicList(songList: musicArr! as! [SongItem]))
                    } else if type == "album" {
                        let data = dic.value(forKey: "data") as! NSDictionary
                        let albumList:NSArray = data.value(forKey: "list") as! NSArray
                        let albumArr = [SearchAlbumItem].deserialize(from: albumList)
                        callback(albumArr! as! [SearchAlbumItem])
                    } else if type == "songList" {
                        let data = dic.value(forKey: "data") as! NSDictionary
                        let songListList:NSArray = data.value(forKey: "list") as! NSArray
                        let songListArr = [SongListItem].deserialize(from: songListList)
                        callback(songListArr! as! [SongListItem])
                    } else if type == "mv" {
                        let data = dic.value(forKey: "data") as! NSDictionary
                        let mvList:NSArray = data.value(forKey: "list") as! NSArray
                        let mvArr = [SearchMVItem].deserialize(from: mvList)
                        callback(mvArr! as! [SearchMVItem])
                    } else if type == "lrc" {
                        let data = dic.value(forKey: "data") as! NSDictionary
                        let lrcList:NSArray = data.value(forKey: "list") as! NSArray
                        let lrcArr = [SearchLrcItem].deserialize(from: lrcList)
                        callback(lrcArr! as! [SearchLrcItem])
                    }
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
    
    /// 获取歌单详情
    ///
    /// - Parameters:
    ///   - id: 歌单ID
    ///   - callback: 接口回调
    class func getSongListDetail(id:String,callback:@escaping (SongListDetail?)->Void) {
        self.post(url:"https://v1.itooi.cn/tencent/songList",parameters: ["id":id,"format":0]) { (dic:AnyObject) in
            if((dic.value(forKey: "code") as! Int) < 0) {
                callback(nil)
            } else {
                if((dic.value(forKey: "code") as! Int) == 200) {
                    let data:NSArray = dic.value(forKey: "data") as! NSArray
                    let songListDetail = SongListDetail.deserialize(from: data[0] as? NSDictionary)
                    callback(songListDetail!)
                } else {
                    MBProgressHUD.showError(error: dic.value(forKey: "msg") as? String)
                    callback(nil)
                }
            }
        }
    }
    
    
    /// 获取歌单分类
    ///
    /// - Parameter callback: 接口回调
    class func getSongListCategory(callback:@escaping ([SongListCategoryGroupItem])->Void) -> Void {
        self.post(url:"https://v1.itooi.cn/tencent/songList/category",parameters: [:]) { (dic:AnyObject) in
            if((dic.value(forKey: "code") as! Int) < 0) {
                callback([])
                return
            } else {
                if((dic.value(forKey: "code") as! Int) == 200) {
                    let categoryList:NSArray = dic.value(forKey: "data") as! NSArray
                    let categoryArr = [SongListCategoryGroupItem].deserialize(from: categoryList)
                    callback(categoryArr! as! [SongListCategoryGroupItem])
                } else {
                    MBProgressHUD.showError(error: dic.value(forKey: "msg") as? String)
                    callback([])
                }
            }
        }
    }
    
    /// 获取MV详情
    ///
    /// - Parameters:
    ///   - id: MV的id
    ///   - callback: 接口回调
    class func getMVDetail(id:String,callback:@escaping (MVDetail?)->Void) -> Void {
        self.post(url:"https://v1.itooi.cn/tencent/mv",parameters: ["id":id]) { (dic:AnyObject) in
            if((dic.value(forKey: "code") as! Int) < 0) {
                callback(nil)
            } else {
                if((dic.value(forKey: "code") as! Int) == 200) {
                    let data:NSDictionary = dic.value(forKey: "data") as! NSDictionary
                    let detail = MVDetail.deserialize(from: data.value(forKey: id) as? NSDictionary)
                    callback(detail)
                } else {
                    MBProgressHUD.showError(error: dic.value(forKey: "msg") as? String)
                    callback(nil)
                }
            }
        }
    }
    
    /// 获取专辑详情
    ///
    /// - Parameters:
    ///   - id: 专辑ID
    ///   - callback: 接口回调
    class func getAlbumDetail(id:String,callback:@escaping (AlbumDetail?)->Void) -> Void {
        self.post(url:"https://v1.itooi.cn/tencent/album",parameters: ["id":id,"format":0]) { (dic:AnyObject) in
            if((dic.value(forKey: "code") as! Int) < 0) {
                callback(nil)
            } else {
                if((dic.value(forKey: "code") as! Int) == 200) {
                    let data:NSDictionary = dic.value(forKey: "data") as! NSDictionary
                    let detail = AlbumDetail.deserialize(from: data)
                    callback(detail)
                } else {
                    MBProgressHUD.showError(error: dic.value(forKey: "msg") as? String)
                    callback(nil)
                }
            }
        }
    }
    
    
    /// 歌手分类
    ///
    /// - Parameter callback: 接口回调
    class func getArtistCategory(callback:@escaping (SingerCategory?)->Void) -> Void {
        self.post(url:"https://v1.itooi.cn/tencent/artist/category",parameters: [:]) { (dic:AnyObject) in
            if((dic.value(forKey: "code") as! Int) < 0) {
                callback(nil)
            } else {
                if((dic.value(forKey: "code") as! Int) == 200) {
                    let data:NSDictionary = dic.value(forKey: "data") as! NSDictionary
                    let category = SingerCategory.deserialize(from: data)
                    callback(category)
                } else {
                    MBProgressHUD.showError(error: dic.value(forKey: "msg") as? String)
                    callback(nil)
                }
            }
        }
    }
    
    /// 歌手列表
    ///
    /// - Parameters:
    ///   - sexId: 性别ID
    ///   - areaId: 地区ID
    ///   - genre: 类型ID
    ///   - index: 索引
    ///   - pageSize: 获取条数
    ///   - page: 页码
    ///   - callback: 接口回调
    class func getSingerList(sexId:Int,areaId:Int,genre:Int,index:Int,pageSize:Int,page:Int,callback:@escaping ([ArtistItem])->Void) -> Void {
        self.post(url:"https://v1.itooi.cn/tencent/artist/list",parameters: ["sexId":sexId,"areaId":areaId,"genre":genre,"index":index,"pageSize":pageSize,"page":page]) { (dic:AnyObject) in
            if((dic.value(forKey: "code") as! Int) < 0) {
                callback([])
                return
            } else {
                if((dic.value(forKey: "code") as! Int) == 200) {
                    let data = dic.value(forKey: "data") as! NSArray;
                    let singerList = [ArtistItem].deserialize(from: data)
                    callback(singerList as! [ArtistItem])
                } else {
                    MBProgressHUD.showError(error: dic.value(forKey: "msg") as? String)
                    callback([])
                }
            }
        }
    }
    
    /// 歌手详情
    ///
    /// - Parameters:
    ///   - id: 歌手id
    ///   - callback: 接口回调
    class func getArtistDetail(id:String,callback:@escaping (ArtistDetail?)->Void) -> Void {
        self.post(url:"https://v1.itooi.cn/tencent/artist",parameters: ["id":id]) { (dic:AnyObject) in
            if((dic.value(forKey: "code") as! Int) < 0) {
                callback(nil)
            } else {
                if((dic.value(forKey: "code") as! Int) == 200) {
                    let data:NSDictionary = dic.value(forKey: "data") as! NSDictionary
                    let detail = ArtistDetail.deserialize(from: data)
                    callback(detail)
                } else {
                    MBProgressHUD.showError(error: dic.value(forKey: "msg") as? String)
                    callback(nil)
                }
            }
        }
    }
    
    /// 歌手音乐
    ///
    /// - Parameters:
    ///   - id: 歌手id
    ///   - pageSize: 获取条数
    ///   - page: 分页
    ///   - callback: 接口回调
    class func getArtistMusicList(id:String,pageSize:Int,page:Int,callback:@escaping ([ArtistMusicItem])->Void) -> Void {
        self.post(url:"https://v1.itooi.cn/tencent/song/artist",parameters: ["id":id,"format":0,"pageSize":pageSize,"page":page]) { (dic:AnyObject) in
            if((dic.value(forKey: "code") as! Int) < 0) {
                callback([])
                return
            } else {
                if((dic.value(forKey: "code") as! Int) == 200) {
                    let data = dic.value(forKey: "data") as! NSArray;
                    let musicList = [ArtistMusicItem].deserialize(from: data)
                    callback(musicList as! [ArtistMusicItem])
                } else {
                    MBProgressHUD.showError(error: dic.value(forKey: "msg") as? String)
                    callback([])
                }
            }
        }
    }
    
    /// 歌手专辑
    ///
    /// - Parameters:
    ///   - id: 歌手id
    ///   - callback: 接口回调
    class func getArtistAlbumList(id:String,callback:@escaping ([ArtistAlbumItem])->Void) -> Void {
        self.post(url:"https://v1.itooi.cn/tencent/album/artist",parameters: ["id":id]) { (dic:AnyObject) in
            if((dic.value(forKey: "code") as! Int) < 0) {
                callback([])
                return
            } else {
                if((dic.value(forKey: "code") as! Int) == 200) {
                    let data = dic.value(forKey: "data") as! NSArray;
                    let albumList = [ArtistAlbumItem].deserialize(from: data)
                    callback(albumList as! [ArtistAlbumItem])
                } else {
                    MBProgressHUD.showError(error: dic.value(forKey: "msg") as? String)
                    callback([])
                }
            }
        }
    }
    
    /// 歌手MV
    ///
    /// - Parameters:
    ///   - id: 歌手id
    ///   - pageSize: 获取条数
    ///   - page: 分页
    ///   - callback: 接口回调
    class func getArtistMVList(id:String,pageSize:Int,page:Int,callback:@escaping ([ArtistMVItem])->Void) -> Void {
        self.post(url:"https://v1.itooi.cn/tencent/mv/artist",parameters: ["id":id,"pageSize":pageSize,"page":page]) { (dic:AnyObject) in
            if((dic.value(forKey: "code") as! Int) < 0) {
                callback([])
                return
            } else {
                if((dic.value(forKey: "code") as! Int) == 200) {
                    let data = dic.value(forKey: "data") as! NSArray;
                    let mvList = [ArtistMVItem].deserialize(from: data)
                    callback(mvList as! [ArtistMVItem])
                } else {
                    MBProgressHUD.showError(error: dic.value(forKey: "msg") as? String)
                    callback([])
                }
            }
        }
    }
    
}
