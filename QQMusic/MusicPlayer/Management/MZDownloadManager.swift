//
//  MZDownloadManager.swift
//  MyFirstSwiftProject
//
//  Created by 曾龙 on 17/4/9.
//  Copyright © 2017年 scinan. All rights reserved.
//

import UIKit

enum DownloadTaskNotification: String {
    
    case Progress = "downloadNotificationProgress"
    case Finish = "downloadNotificationFinish"
    
}

struct DownloadTask {
    var url:URL
    var taskIdentifier:Int
    var finished:Bool = false
    
    init(url:URL,taskIdentifier:Int) {
        self.url = url
        self.taskIdentifier = taskIdentifier
    }
}

class MZDownloadManager: NSObject, URLSessionDownloadDelegate{
    
    private var session:URLSession?
    var taskList:[DownloadTask] = [DownloadTask]()
    static var sharedInstance:MZDownloadManager = MZDownloadManager()
    
    override init() {
        super.init()
        
        let config = URLSessionConfiguration.background(withIdentifier: "downloadSession")
        self.session = URLSession.init(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        self.taskList = [DownloadTask]()
        self.loadTaskList()
    }
    
    func unFinishedTask() -> [DownloadTask] {
        return taskList.filter({ (task) -> Bool in
            return (task.finished == false)
        })
    }
    
    func finishedTask() -> [DownloadTask] {
        return taskList.filter({ (task) -> Bool in
            return task.finished
        })
    }
    
    func saveTaskList() {
        let jsonArray = NSMutableArray.init()
        for task in taskList {
            let jsonItem = NSMutableDictionary.init()
            jsonItem["url"] = task.url.absoluteString
            jsonItem["taskIdentifier"] = NSNumber.init(value: task.taskIdentifier)
            jsonItem["finished"] = NSNumber.init(value: task.finished)
            
            jsonArray.add(jsonItem)
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: JSONSerialization.WritingOptions.prettyPrinted)
            UserDefaults.standard.set(jsonData, forKey: "taskList")
        } catch  {
            
        }
    }
    
    func loadTaskList() {
        if let jsonData:Data = UserDefaults.standard.data(forKey: "taskList") {
            do {
                guard let jsonArray:NSArray = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments)  as? NSArray else {return}
                for jsonItem in jsonArray {
                    if let item:NSDictionary = jsonItem as? NSDictionary{
                        guard let urlString = item["url"] as? String else {
                            return
                        }
                        guard let taskIdentifier = item["taskIdentifier"] as? Int else {
                            return
                        }
                        guard let finished = item["finished"] as? Bool else {
                            return
                        }
                        
                        var downloadTask = DownloadTask.init(url: URL.init(string: urlString)!, taskIdentifier: taskIdentifier)
                        downloadTask.finished = finished
                        self.taskList.append(downloadTask)
                    }
                }
            } catch  {
                
            }
        }
    }
    
    //删除歌曲
    func deleteTask(task:DownloadTask) {
        for i in 0..<self.taskList.count {
            let task1 = self.taskList[i]
            if task1.taskIdentifier == task.taskIdentifier {
                self.taskList.remove(at: i)
                self.saveTaskList()
                return
            }
        }
    }

    //新建下载歌曲
    func newTask(url:String) {
        if let url = URL.init(string: url) {
            //下载歌曲
            let downloadTask = self.session?.downloadTask(with: url)
            downloadTask?.resume()
            
            let task = DownloadTask.init(url: url, taskIdentifier: (downloadTask?.taskIdentifier)!)
            self.taskList.append(task)
            self.saveTaskList()
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        var fileName = ""
        for i in 0..<self.taskList.count {
            if self.taskList[i].taskIdentifier == downloadTask.taskIdentifier {
                self.taskList[i].finished = true
                fileName = self.taskList[i].url.lastPathComponent
            }
        }
        if let documentUrl = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first {
            let destUrl = documentUrl.appendingPathComponent(fileName)
            do {
                try FileManager.default.moveItem(at: location, to: destUrl)
                let arr = fileName.components(separatedBy: ".")
                MusicDatabaseManager.share.insertDownloadPath(songid: arr[0], path: (destUrl.absoluteURL.absoluteString as NSString).substring(from: 7))
            } catch  {
                
            }
        }
        
        self.saveTaskList()
        NotificationCenter.default.post(name: Notification.Name.init(DownloadTaskNotification.Finish.rawValue), object: downloadTask.taskIdentifier)
        print("-----------------------下载完成----------------------")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progressInfo = ["taskIdentifier":downloadTask.taskIdentifier,"totalBytesWritten":NSNumber.init(value: totalBytesWritten),"totalBytesExpectedToWrite":NSNumber.init(value: totalBytesExpectedToWrite)] as [String : Any]
        NotificationCenter.default.post(name: Notification.Name.init(DownloadTaskNotification.Progress.rawValue), object: progressInfo)
    }
    
}
