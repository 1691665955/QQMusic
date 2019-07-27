//
//  MusicDownloadCell.swift
//  MyFirstSwiftProject
//
//  Created by 曾龙 on 17/4/9.
//  Copyright © 2017年 scinan. All rights reserved.
//

import UIKit

class MusicDownloadCell: UITableViewCell {

    var titleLB:UILabel!
    var progressView:UIProgressView!
    var sizeLB:UILabel!
    var downloadTask:DownloadTask!
    
    func updateTask(task:DownloadTask) {
        self.downloadTask = task
        let fileName = self.downloadTask.url.lastPathComponent
        let arr = fileName.components(separatedBy: ".")
        let musicItem = MusicDatabaseManager.share.queryMusicDownload(songid: arr[0])
        self.titleLB.text = musicItem.songname
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setupUI()  {
        self.backgroundColor = UIColor.clear
        
        let bgView = UIView.init(frame: CGRect.init(x: 10, y: 5, width: SCREEN_WIDTH-20, height: 55))
        bgView.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        bgView.layer.cornerRadius = 5
        bgView.layer.masksToBounds = true
        self.addSubview(bgView)
        
        self.titleLB = UILabel.init(frame: CGRect.init(x: 20, y: 5, width: 260, height: 20))
        self.titleLB.backgroundColor = UIColor.clear
        self.titleLB.textColor = UIColor.white
        self.titleLB.textAlignment = NSTextAlignment.left
        self.titleLB.font = UIFont.systemFont(ofSize: 15)
        bgView.addSubview(self.titleLB)

        self.progressView = UIProgressView.init(frame: CGRect.init(x: 20, y: 30, width: 260, height: 10))
        self.progressView.progressTintColor = MainColor
        self.progressView.trackTintColor = UIColor.white
        self.progressView.transform = CGAffineTransform.init(scaleX: 1.0, y: 2.0)
        bgView.addSubview(self.progressView)
        
        self.sizeLB = UILabel.init(frame: CGRect.init(x: 200, y: 40, width: 100, height: 15))
        self.sizeLB.backgroundColor = UIColor.clear
        self.sizeLB.textColor = UIColor.white
        self.sizeLB.textAlignment = NSTextAlignment.left
        self.sizeLB.font = UIFont.systemFont(ofSize: 10)
        bgView.addSubview(self.sizeLB)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateProgress(notifiation:)), name: Notification.Name.init(DownloadTaskNotification.Progress.rawValue), object: nil)
    }
    
    @objc func updateProgress(notifiation:Notification) {
        guard let info = notifiation.object as? NSDictionary else { return }
        let taskIdentifier = info.value(forKey: "taskIdentifier") as? Int
        
        if taskIdentifier == self.downloadTask.taskIdentifier {
            guard let written = info["totalBytesWritten"] as? NSNumber else { return }
            guard let total = info["totalBytesExpectedToWrite"] as? NSNumber else { return }
            
            self.progressView.progress = written.floatValue/total.floatValue
            
            let formattedWrittenSize = ByteCountFormatter.string(fromByteCount: written.int64Value, countStyle: ByteCountFormatter.CountStyle.file)
            let formattedTotalSize = ByteCountFormatter.string(fromByteCount: total.int64Value, countStyle: ByteCountFormatter.CountStyle.file)
            
            self.sizeLB.text = "\(formattedWrittenSize) / \(formattedTotalSize)"
            //            let percentage = Int((written.doubleValue / total.doubleValue) * 100.0)
            //            self.labelProgress.text = "\(percentage)%"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
