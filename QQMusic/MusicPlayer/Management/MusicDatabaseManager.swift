//
//  MusicDatabaseManager.swift
//  MyFirstSwiftProject
//
//  Created by 曾龙 on 17/4/6.
//  Copyright © 2017年 scinan. All rights reserved.
//

import UIKit
import FMDB

class MusicDatabaseManager: NSObject {
    let song_id = "songid"
    let song_path = "songpath"
    let song_lyric = "songlyric"
    let song_model = "songmodel"
    let song_playTime = "songplaytime"
    let song_downloadTime = "songdownloadtime"
    let song_loveTime = "songlovetime"
    let song_album_large = "songalbumlarge"
    let song_album_small = "songalbumsmall"
    
    
    //创建单例对象
    static let share:MusicDatabaseManager = MusicDatabaseManager()
    //数据库文件名
    let databaseFileName = "music.db"
    let downloadDBFileName = "download.db"
    
    //数据库文件路径
    var pathToDatabase:String!
    var pathToDownloadDB:String!
    
    
    //FMDatabase对象用于访问和操作实际的数据库
    var database:FMDatabase!
    //下载专用
    var downloadDB:FMDatabase!
    
    var databaseQueue:FMDatabaseQueue!
    var downloadDBQueue:FMDatabaseQueue!
    
    
    override init() {
        super.init()
        //创建数据库文件路径
        let documentDirctory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        pathToDatabase = documentDirctory?.appending("/\(databaseFileName)")
        pathToDownloadDB = documentDirctory?.appending("/\(downloadDBFileName)")
        self.creatDatabase()
        self.creatDownloadDB()
    }
    
    //创建数据库
    func creatDatabase() {
        //如果数据库文件不存在那么就创建，存在就不创建
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase.init(path: pathToDatabase)
            if database != nil {
                //数据库是否被打开
                if database.open() {
                    //为数据库创建表
                    let sql_stmt = "CREATE TABLE IF NOT EXISTS MUSICS (\(song_id) TEXT PRIMARY KEY, \(song_model) BLOB, \(song_playTime) INTEGER,\(song_loveTime) INTEGER)"
                    if database.executeStatements(sql_stmt) {
                        self.databaseQueue = FMDatabaseQueue.init(path: pathToDatabase)
                    }
                }
            }
        } else {
            database = FMDatabase.init(path: pathToDatabase)
            databaseQueue = FMDatabaseQueue.init(path: pathToDatabase)
            database.open()
        }
    }
    
    //创建下载数据库
    func creatDownloadDB() {
        //如果数据库文件不存在那么就创建，存在就不创建
        if !FileManager.default.fileExists(atPath: pathToDownloadDB) {
            downloadDB = FMDatabase.init(path: pathToDownloadDB)
            if downloadDB != nil {
                //数据库是否被打开
                if downloadDB.open() {
                    //为数据库创建表
                    let sql_stmt = "CREATE TABLE IF NOT EXISTS MUSICS (\(song_id) TEXT PRIMARY KEY, \(song_model) BLOB, \(song_lyric) TEXT, \(song_path) TEXT,\(song_album_large) BLOB,\(song_album_small) BLOB)"
                    if downloadDB.executeStatements(sql_stmt) {
                        self.downloadDBQueue = FMDatabaseQueue.init(path: pathToDownloadDB)
                    }
                }
            }
        } else {
            downloadDB = FMDatabase.init(path: pathToDownloadDB)
            downloadDBQueue = FMDatabaseQueue.init(path: pathToDownloadDB)
            downloadDB.open()
        }
    }
    
    /*****************************************播放历史相关***********************************************/
    //根据歌曲id查询歌曲信息
    func queryMusicItem(songid:String) -> MusicItem? {
        
        var model :MusicItem!
        self.databaseQueue.inDatabase { (database) in
            let sql = "SELECT * FROM MUSICS WHERE \(self.song_id) = ?"
            let result = database.executeQuery(sql, withArgumentsIn: [songid])
            while (result?.next())! {
                model = NSKeyedUnarchiver.unarchiveObject(with: (result?.data(forColumn: "\(self.song_model)"))!) as? MusicItem
            }
        }
        return model
    }
    
    //查询是否存在指定music
    func queryMusic(musicItem:MusicItem) -> Bool {
        
        var isExist = false
        self.databaseQueue.inDatabase { (database) in
            let sql = "SELECT * FROM MUSICS WHERE \(self.song_id) = ?"
            let result = database.executeQuery(sql, withArgumentsIn: [musicItem.mid as Any])
            while (result?.next())! {
                isExist = true
            }
        }
        return isExist
    }
    
    //插入播放历史
    func insertHistoryMusic(musicItem:MusicItem) {
        if self.queryMusic(musicItem: musicItem) {
            self.updateHistoryMuisc(musicItem: musicItem)
            return
        }
        self.databaseQueue.inDatabase { (database) in
            let sql = "INSERT INTO MUSICS (\(self.song_id),\(self.song_model),\(self.song_playTime),\(self.song_loveTime)) VALUES (?,?,?,?)"
            let modelData = NSKeyedArchiver.archivedData(withRootObject: musicItem)
            let date = NSDate.init()
            let time:TimeInterval = date.timeIntervalSince1970
            let time_Int = Int(time)
            database.executeUpdate(sql, withArgumentsIn: [musicItem.mid as Any,modelData,time_Int,0])
        }
    }

    //更新播放历史
    func updateHistoryMuisc(musicItem:MusicItem) {
        self.databaseQueue.inDatabase { (database) in
            let sql = "UPDATE MUSICS SET \(self.song_playTime) = ? WHERE \(self.song_id) = ?"
            let date = NSDate.init()
            let time:TimeInterval = date.timeIntervalSince1970
            let time_Int = Int(time)
            database.executeUpdate(sql, withArgumentsIn: [time_Int,musicItem.mid as Any])
        }
    }

    
    //查询播放历史记录
    func queryHistoryMusics()->NSArray {
        
        let modelArr = NSMutableArray.init()
        self.databaseQueue.inDatabase { (database) in
            let sql = "SELECT * FROM MUSICS WHERE \(self.song_playTime) > 0 ORDER BY \(self.song_playTime) DESC "
            let result = database.executeQuery(sql, withArgumentsIn: [])
            while (result?.next())! {
                let model:MusicItem = NSKeyedUnarchiver.unarchiveObject(with: (result?.data(forColumn: "\(self.song_model)"))!) as! MusicItem
                modelArr.add(model)
            }
        }
        return modelArr
    }
    
    
    //删除播放历史记录
    func deleteHistoryMusics() {
        self.databaseQueue.inDatabase { (database) in
            //删除只是播放过的歌曲
            let sql = "DELETE FROM MUSICS WHERE \(self.song_loveTime) = 0"
            database.executeUpdate(sql, withArgumentsIn: [])
            
            //设置既播放过又喜欢或下载过的歌曲
            let sql1 = "UPDATE MUSICS SET \(self.song_playTime) = 0"
            database.executeUpdate(sql1, withArgumentsIn: [])
        }
    }
    
    
    /*******************************************喜欢歌曲相关**********************************************/
    
    //查询指定歌曲是否为喜欢歌曲
    func queryLoveMusic(musicItem:MusicItem) -> Bool {
        var isExist = false
        self.databaseQueue.inDatabase { (database) in
            let sql = "SELECT * FROM MUSICS WHERE \(self.song_id) = ? AND \(self.song_loveTime) > 0"
            let result = database.executeQuery(sql, withArgumentsIn: [musicItem.mid as Any])
            while (result?.next())! {
                isExist = true
            }
        }
        return isExist
    }
    
    
    //插入喜欢歌曲
    func insertLoveMusic(musicItem:MusicItem) {
        if self.queryMusic(musicItem: musicItem) {
            self.updateLoveMuisc(musicItem: musicItem)
            return
        }
        self.databaseQueue.inDatabase { (database) in
            let sql = "INSERT INTO MUSICS (\(self.song_id),\(self.song_model),\(self.song_playTime),\(self.song_loveTime)) VALUES (?,?,?,?)"
            let modelData = NSKeyedArchiver.archivedData(withRootObject: musicItem)
            let date = NSDate.init()
            let time:TimeInterval = date.timeIntervalSince1970
            let time_Int = Int(time)
            database.executeUpdate(sql, withArgumentsIn: [musicItem.mid as Any,modelData,0,time_Int])
        }
    }
    
    
    
    //更新喜欢歌曲
    func updateLoveMuisc(musicItem:MusicItem) {
        self.databaseQueue.inDatabase { (database) in
            let sql = "UPDATE MUSICS SET \(self.song_loveTime) = ? WHERE \(self.song_id) = ?"
            let date = NSDate.init()
            let time:TimeInterval = date.timeIntervalSince1970
            var time_Int = Int(time)
            //如果记录为喜欢，则改为不喜欢
            
            let sql1 = "SELECT * FROM MUSICS WHERE \(self.song_id) = ? AND \(self.song_loveTime) > 0"
            let result = self.database.executeQuery(sql1, withArgumentsIn: [musicItem.mid as Any])
            while (result?.next())! {
                time_Int = 0
            }
            database.executeUpdate(sql, withArgumentsIn: [time_Int,musicItem.mid as Any])
        }
    }
    
    
    //查询所有喜欢的歌曲
    func queryAllLoveMusic()->NSArray {
        
        let modelArr = NSMutableArray.init()
        self.databaseQueue.inDatabase { (database) in
            let sql = "SELECT * FROM MUSICS WHERE \(self.song_loveTime) > 0 ORDER BY \(self.song_loveTime) DESC "
            let result = database.executeQuery(sql, withArgumentsIn: [])
            
            while (result?.next())! {
                let model:MusicItem = NSKeyedUnarchiver.unarchiveObject(with: (result?.data(forColumn: "\(self.song_model)"))!) as! MusicItem
                modelArr.add(model)
            }
        }
        return modelArr
    }
    
    
    //删除全部喜欢的歌曲
    func deleteAllLoveMusic() {
        self.databaseQueue.inDatabase { (database) in
            //删除只是喜欢的歌曲
            let sql = "DELETE FROM MUSICS WHERE  \(self.song_playTime) = 0"
            database.executeUpdate(sql, withArgumentsIn: [])
            
            //设置既喜欢又播放过的歌曲
            let sql1 = "UPDATE MUSICS SET \(self.song_loveTime) = 0"
            database.executeUpdate(sql1, withArgumentsIn: [])
        }
    }
    
    
    /******************************************下载歌曲相关**************************************/
    //根据songid查询指定歌曲
    func queryMusicDownload(songid:String) -> MusicItem {
        var model:MusicItem!
        self.downloadDBQueue.inDatabase { (database) in
            let sql = "SELECT * FROM MUSICS WHERE \(self.song_id) = ?"
            let result = database.executeQuery(sql, withArgumentsIn: [songid])
            while (result?.next())! {
                model = NSKeyedUnarchiver.unarchiveObject(with: (result?.data(forColumn: "\(self.song_model)"))!) as? MusicItem
            }
        }
        return model
    }
    
    
    //查询指定歌曲是否已经下载
    func queryMusicDownload(musicItem:MusicItem) -> Bool {
        var isExist = false
        self.downloadDBQueue.inDatabase { (database) in
            let sql = "SELECT * FROM MUSICS WHERE \(self.song_id) = ?"
            let result = database.executeQuery(sql, withArgumentsIn: [musicItem.mid as Any])
            while (result?.next())! {
                isExist = true
            }
        }
        return isExist
    }
    
    
    //查询全部下载歌曲
    func queryAllDownloadMusic()->NSArray {
        let modelArr = NSMutableArray.init()
        self.downloadDBQueue.inDatabase { (database) in
            let sql = "SELECT * FROM MUSICS"
            let result = database.executeQuery(sql, withArgumentsIn: [])
            
            while (result?.next())! {
                let model:MusicItem = NSKeyedUnarchiver.unarchiveObject(with: (result?.data(forColumn: "\(self.song_model)"))!) as! MusicItem
                modelArr.add(model)
            }
        }
        return modelArr
    }
    

    
    //查询下载地址
    func queryDownloadPath(musicItem:MusicItem) -> String {
        var path = ""
        self.downloadDBQueue.inDatabase { (database) in
            let sql = "SELECT * FROM MUSICS WHERE \(self.song_id) = ? AND \(self.song_path) != ?"
            let result = database.executeQuery(sql, withArgumentsIn: [musicItem.mid as Any,""])
            while (result?.next())! {
                path = (result?.string(forColumn: "\(self.song_path)"))!
            }
        }
        return path
    }
    
    
    //插入下载歌曲
    func insertDownloadMusic(musicItem:MusicItem) {
        self.downloadDBQueue.inDatabase { (database) in
            let sql = "INSERT INTO MUSICS (\(self.song_id),\(self.song_model),\(self.song_lyric),\(self.song_path)) VALUES (?,?,?,?)"
            let modelData = NSKeyedArchiver.archivedData(withRootObject: musicItem)
            database.executeUpdate(sql, withArgumentsIn: [musicItem.mid as Any,modelData,"",""])
        }
    }

    
    //插入下载歌曲地址
    func insertDownloadPath(songid:String,path:String) {
        self.downloadDBQueue.inDatabase { (database) in
            let sql = "UPDATE MUSICS SET \(self.song_path) = ? WHERE \(self.song_id) = ?"
            database.executeUpdate(sql, withArgumentsIn: [path,songid])
        }
    }
    
    
    //插入歌词
    func insertMusicLyric(songid:String,lyric:String) {
        self.downloadDBQueue.inDatabase { (database) in
            let sql = "UPDATE MUSICS SET \(self.song_lyric) = ? WHERE \(self.song_id) = ?"
            database.executeUpdate(sql, withArgumentsIn: [lyric,songid])
        }
    }
    
    
    //查询歌词
    func queryLyric(songid:String) -> String {
        var lyric = ""
        self.downloadDBQueue.inDatabase { (database) in
            let sql = "SELECT * FROM MUSICS WHERE \(self.song_id) = ?"
            let result = database.executeQuery(sql, withArgumentsIn: [songid])
            while (result?.next())! {
                lyric = (result?.string(forColumn: "\(self.song_lyric)"))!
            }
        }
        return lyric
    }
    

    
    //插入大歌曲图片
    func insertLargeAlbumImageData(songid:String,imgData:Data) {
        self.downloadDBQueue.inDatabase { (database) in
            let sql = "UPDATE MUSICS SET \(self.song_album_large) = ? WHERE \(self.song_id) = ?"
            database.executeUpdate(sql, withArgumentsIn: [imgData,songid])
        }
    }
    

    
    //插入小歌曲图片
    func insertSmallAlbumImageData(songid:String,imgData:Data) {
        self.downloadDBQueue.inDatabase { (database) in
            let sql = "UPDATE MUSICS SET \(self.song_album_small) = ? WHERE \(self.song_id) = ?"
            database.executeUpdate(sql, withArgumentsIn: [imgData,songid])
        }
    }
    
    
    //查询小歌曲图片
    func querySmallAlbumImage(songid:String) -> Data? {
        var imgData:Data!
        self.downloadDBQueue.inDatabase { (database) in
            let sql = "SELECT * FROM MUSICS WHERE \(self.song_id) = ?"
            let result = database.executeQuery(sql, withArgumentsIn: [songid])
            while (result?.next())! {
                imgData = result?.data(forColumn: "\(self.song_album_small)")
            }
        }
        return imgData
    }
    
    //查询大歌曲图片
    func queryLargeAlbumImage(songid:String) -> Data? {
        var imgData:Data!
        self.downloadDBQueue.inDatabase { (database) in
            let sql = "SELECT * FROM MUSICS WHERE \(self.song_id) = ?"
            let result = database.executeQuery(sql, withArgumentsIn: [songid])
            while (result?.next())! {
                imgData = result?.data(forColumn: "\(self.song_album_large)")
            }
        }
        return imgData
    }
    
    //删除歌曲
    func deleteDownloadMusic(musicItem:MusicItem) {
        do {
            let documentUrl = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first
            try FileManager.default.removeItem(at: (documentUrl?.appendingPathComponent((URL.init(string: musicItem.getUrl())?.lastPathComponent)!))!)
            self.downloadDBQueue.inDatabase { (database) in
                let sql = "DELETE FROM MUSICS WHERE  \(self.song_id) = ?"
                database.executeUpdate(sql, withArgumentsIn: [musicItem.mid as Any])
            }
        } catch {
            print("删除失败")
        }
    }
    
}
