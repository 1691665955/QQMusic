//
//  MusicMVDetailVC.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/17.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit
import AVFoundation

class MusicMVDetailVC: UIViewController {

    var mvItem:MVItem!
    var player:AVPlayer!
    var playerItem:AVPlayerItem!
    var avLayer:AVPlayerLayer!
    var playerView:UIView!
    var fullScreen = false
    var progressView:UISlider!
    var currentTimeLB:UILabel!
    var timer:Timer!
    var bgView:UIView!
    var playBtn:UIButton!
    var fullPlayerView:UIView!
    var fullPlayBtn:UIButton!
    var fullProgressView:UISlider!
    var fullCurrentTimeLB:UILabel!
    var fullDurationLB:UILabel!
    var mvDetail:MVDetail!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = mvItem.title;
        self.view.backgroundColor = .white;
        
        NotificationCenter.default.addObserver(self, selector: #selector(seekToStart), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        bgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH/640*360));
        bgView.backgroundColor = .white
        bgView.isUserInteractionEnabled = true;
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(showOperation));
        bgView.addGestureRecognizer(tap);
        self.view.addSubview(bgView);
        
        playerItem = AVPlayerItem.init(url: URL.init(string: mvItem.getPlayUrl())!)
        player = AVPlayer.init(playerItem: playerItem);
        avLayer = AVPlayerLayer(player: player);
        avLayer.videoGravity = AVLayerVideoGravity.resizeAspect;
        avLayer.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH/640*360);
        playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil);
        playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil);
        self.view.layer.addSublayer(avLayer);
        
        playerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH/640*360));
        playerView.isUserInteractionEnabled = true;
        playerView.isHidden = true;
        
        let backBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40));
        backBtn.setImage(UIImage.init(named: "mv_player_back"), for: .normal);
        backBtn.addTarget(self, action: #selector(back), for: .touchUpInside);
        playerView.addSubview(backBtn);
        
        playBtn = UIButton.init(type: .custom);
        playBtn.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50);
        playBtn.center = playerView.center;
        playBtn.setImage(UIImage.init(named: "mv_pause"), for: .normal);
        playBtn.addTarget(self, action: #selector(playOrPause), for: .touchUpInside);
        playerView.addSubview(playBtn)
        
        progressView = UISlider.init(frame: CGRect.init(x: -2, y: SCREEN_WIDTH/640*360-5, width: SCREEN_WIDTH+4, height: 10))
        progressView.minimumTrackTintColor = MainColor
        progressView.maximumTrackTintColor = UIColor.gray
        progressView.setThumbImage(UIImage.init(named: "mv_slider"), for: UIControl.State.normal)
        playerView.addSubview(self.progressView)
        progressView.addTarget(self, action: #selector(updateMVProgress(slider:)), for: UIControl.Event.valueChanged)
        
        currentTimeLB = UILabel.init(frame: CGRect.init(x: 10, y: SCREEN_WIDTH/640*360-20, width: 80, height: 10))
        currentTimeLB.textAlignment = NSTextAlignment.left
        currentTimeLB.backgroundColor = UIColor.clear
        currentTimeLB.textColor = UIColor.white
        currentTimeLB.font = UIFont.systemFont(ofSize: 10)
        playerView.addSubview(currentTimeLB)
        
        let fullScreenBtn = UIButton.init(type: .custom);
        fullScreenBtn.frame = CGRect.init(x: SCREEN_WIDTH-40, y: SCREEN_WIDTH/640*360-30, width: 40, height: 25);
        fullScreenBtn.setImage(UIImage.init(named: "full_screen"), for: .normal);
        fullScreenBtn.backgroundColor = .clear;
        fullScreenBtn.addTarget(self, action: #selector(mvFullScreen), for: .touchUpInside);
        playerView.addSubview(fullScreenBtn)
        
        self.view.addSubview(playerView);
        
        
        //全屏
        fullPlayerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_HEIGHT, height: SCREEN_WIDTH));
        let fullBackBtn = UIButton.init(type: .custom);
        fullBackBtn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40);
        fullBackBtn.setImage(UIImage.init(named: "mv_player_back"), for: .normal);
        fullBackBtn.addTarget(self, action: #selector(mvFullScreen), for: .touchUpInside);
        fullPlayerView.addSubview(fullBackBtn);
        
        fullPlayBtn = UIButton.init(type: .custom);
        fullPlayBtn.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60);
        fullPlayBtn.center = CGPoint.init(x: SCREEN_HEIGHT/2, y: SCREEN_WIDTH/2)
        fullPlayBtn.setImage(UIImage.init(named: "mv_pause"), for: .normal);
        fullPlayBtn.addTarget(self, action: #selector(playOrPause), for: .touchUpInside);
        fullPlayerView.addSubview(fullPlayBtn)
        
        fullProgressView = UISlider.init(frame: CGRect.init(x: 50, y: SCREEN_WIDTH-40, width: SCREEN_HEIGHT-100, height: 10))
        fullProgressView.minimumTrackTintColor = MainColor
        fullProgressView.maximumTrackTintColor = UIColor.gray
        fullProgressView.setThumbImage(UIImage.init(named: "mv_slider"), for: UIControl.State.normal)
        fullProgressView.addTarget(self, action: #selector(updateMVProgress(slider:)), for: UIControl.Event.valueChanged)
        fullPlayerView.addSubview(fullProgressView);
        
        fullCurrentTimeLB = UILabel.init(frame: CGRect.init(x: 0, y: SCREEN_WIDTH-45, width: 50, height: 20))
        fullCurrentTimeLB.textAlignment = NSTextAlignment.center
        fullCurrentTimeLB.backgroundColor = UIColor.clear
        fullCurrentTimeLB.textColor = UIColor.white
        fullCurrentTimeLB.font = UIFont.systemFont(ofSize: 14)
        fullPlayerView.addSubview(fullCurrentTimeLB)
        
        fullDurationLB = UILabel.init(frame: CGRect.init(x: SCREEN_HEIGHT-50, y: SCREEN_WIDTH-45, width: 50, height: 20))
        fullDurationLB.textAlignment = NSTextAlignment.center
        fullDurationLB.backgroundColor = UIColor.clear
        fullDurationLB.textColor = UIColor.white
        fullDurationLB.font = UIFont.systemFont(ofSize: 14)
        fullPlayerView.addSubview(fullDurationLB)
        
        fullPlayerView.layer.setAffineTransform(CGAffineTransform.init(rotationAngle: CGFloat(Double.pi/2)));
        fullPlayerView.layer.position = CGPoint.init(x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT/2)
        fullPlayerView.isHidden = true;
        
        self.view.addSubview(fullPlayerView);
        timer = Timer.init(timeInterval: 1.0, target: self, selector: #selector(timeFun), userInfo: nil, repeats: true);
        timer.fire();
        RunLoop.main.add(timer, forMode: .common);
        
        MZMusicAPIRequest.getMVDetail(id: self.mvItem.vid!) { (detail) in
            if detail != nil {
                self.mvDetail = detail;
                
                let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: SCREEN_WIDTH/640*360, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-SCREEN_WIDTH/640*360));
                
                let logoLB = UILabel.init(frame: CGRect.init(x: 14, y: 18, width: 20, height: 14));
                logoLB.text = "MV";
                logoLB.textColor = MainColor;
                logoLB.font = .boldSystemFont(ofSize: 10);
                logoLB.textAlignment = .center;
                logoLB.layer.cornerRadius = 2;
                logoLB.layer.masksToBounds = true;
                logoLB.layer.borderColor = MainColor.cgColor;
                logoLB.layer.borderWidth = 0.5;
                scrollView.addSubview(logoLB);
                
                let mvNameLB = UILabel.init(frame: CGRect.init(x: 40, y: 15, width: SCREEN_WIDTH-50, height: 20));
                mvNameLB.text = self.mvDetail.name;
                mvNameLB.font = .boldSystemFont(ofSize: 16);
                mvNameLB.numberOfLines = 0;
                let maxSize = CGSize.init(width: SCREEN_WIDTH-50, height: CGFloat.greatestFiniteMagnitude);
                let size = mvNameLB.sizeThatFits(maxSize);
                mvNameLB.frame = CGRect.init(x: 40, y: 15, width: SCREEN_WIDTH-50, height: size.height);
                scrollView.addSubview(mvNameLB);
                
                let avatar = UIImageView.init(frame: CGRect.init(x: 14, y: mvNameLB.frame.maxY+10, width: 14, height: 14));
                avatar.image = UIImage.init(named: "mv_avatar");
                scrollView.addSubview(avatar);
                
                let singerLB = UILabel.init(frame: CGRect.init(x: 32, y: mvNameLB.frame.maxY+10, width: SCREEN_WIDTH-30, height: 14));
                singerLB.text = self.mvDetail.getSingerName();
                singerLB.font = .systemFont(ofSize: 12);
                singerLB.textColor = RGB(r: 136, g: 136, b: 136);
                scrollView.addSubview(singerLB);
                
                let playCountLB = UILabel.init(frame: CGRect.init(x: 14, y: singerLB.frame.maxY+10, width: 100, height: 14));
                playCountLB.font = .systemFont(ofSize: 12);
                playCountLB.textColor = RGB(r: 136, g: 136, b: 136);
                playCountLB.text = String.init(format: "%ld次播放", self.mvDetail.playcnt);
                if (self.mvDetail.playcnt! >= 10000) {
                    playCountLB.text = String(format: "%.1f万次播放", CGFloat(self.mvDetail.playcnt!)/10000.0);
                }
                if (self.mvDetail.playcnt! >= 100000000) {
                    playCountLB.text = String(format: "%.1f亿次播放", CGFloat(self.mvDetail.playcnt!)/100000000.0);
                }
                let maxSize1 = CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: 14);
                let size1 = playCountLB.sizeThatFits(maxSize1);
                playCountLB.frame = CGRect.init(x: 14, y: singerLB.frame.maxY+10, width: size1.width, height: 14)
                scrollView.addSubview(playCountLB);
                
                let timeLB = UILabel.init(frame: CGRect.init(x: playCountLB.frame.maxX+20, y: singerLB.frame.maxY+10, width: 100, height: 14));
                timeLB.font = .systemFont(ofSize: 12);
                timeLB.textColor = RGB(r: 136, g: 136, b: 136);
                let formatter = DateFormatter();
                formatter.dateFormat = "YYYY-MM-dd"
                let time = formatter.string(from: Date.init(timeIntervalSince1970: TimeInterval(self.mvDetail!.pubdate)));
                timeLB.text = time;
                scrollView.addSubview(timeLB);
                
                let descLB = UILabel.init(frame: CGRect.init(x: 14, y: timeLB.frame.maxY+10, width: SCREEN_WIDTH-28, height: 10));
                descLB.textColor = RGB(r: 136, g: 136, b: 136);
                descLB.font = .systemFont(ofSize: 12);
                descLB.numberOfLines = 0;
                descLB.text = self.mvDetail.desc;
                let maxSize2 = CGSize.init(width: SCREEN_WIDTH-28, height: CGFloat.greatestFiniteMagnitude);
                let size2 = descLB.sizeThatFits(maxSize2);
                descLB.frame = CGRect.init(x: 14, y: timeLB.frame.maxY+10, width: SCREEN_WIDTH-28, height: size2.height);
                scrollView.addSubview(descLB);
                
                scrollView.contentSize = CGSize.init(width: 0, height: descLB.frame.maxY+10)
                self.view.addSubview(scrollView);
                self.view.sendSubviewToBack(scrollView);
            }
        }
    }
    
    @objc func seekToStart() -> Void {
        player.seek(to: CMTimeMake(value: 0, timescale: 1));
        playerView.isHidden = false;
        playBtn.setImage(UIImage.init(named: "mv_play"), for: .normal);
    }
    
    @objc func back() -> Void {
        self.navigationController?.popViewController(animated: true);
    }
    
    @objc func playOrPause() -> Void {
        if player.rate == 0 {
            player.play();
            playBtn.setImage(UIImage.init(named: "mv_pause"), for: .normal);
            fullPlayBtn.setImage(UIImage.init(named: "mv_pause"), for: .normal);
            self.perform(#selector(showOperation), with: nil, afterDelay: 3.0);
        } else {
            player.pause();
            playBtn.setImage(UIImage.init(named: "mv_play"), for: .normal);
            fullPlayBtn.setImage(UIImage.init(named: "mv_play"), for: .normal);
        }
    }
    
    @objc func showOperation() -> Void {
        if player.rate == 0 {
            return;
        }
        if fullScreen {
            fullPlayerView.isHidden = !fullPlayerView.isHidden;
            if !fullPlayerView.isHidden {
                self.perform(#selector(showOperation), with: nil, afterDelay: 3.0);
            }
        } else {
            playerView.isHidden = !playerView.isHidden
            if !playerView.isHidden {
                self.perform(#selector(showOperation), with: nil, afterDelay: 3.0);
            }
        }
    }
    
    @objc func updateMVProgress(slider:UISlider) -> Void {
        let durationTime:CMTime = (player.currentItem?.duration)!
        let duration:TimeInterval = CMTimeGetSeconds(durationTime)
        player.currentItem?.seek(to: CMTimeMake(value: Int64(Float(duration)*slider.value), timescale: 1))
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(showOperation), object: nil);
        self.perform(#selector(showOperation), with: nil, afterDelay: 3.0);
    }
    
    @objc func timeFun() -> Void {
        currentTimeLB.text = String.init(format: "%@/%@", getCurrentTime(),getDuration())
        if currentTimeLB.text == "00:00/00:00" {
            progressView.value = 0
        } else {
            progressView.value = Float(CMTimeGetSeconds((player.currentItem?.currentTime())!)/CMTimeGetSeconds(player.currentItem!.duration))
        }
        fullCurrentTimeLB.text = getCurrentTime();
        fullDurationLB.text = getDuration();
        if fullCurrentTimeLB.text == "00:00" {
            fullProgressView.value = 0;
        } else {
            fullProgressView.value = Float(CMTimeGetSeconds((player.currentItem?.currentTime())!)/CMTimeGetSeconds(player.currentItem!.duration))
        }
    }
    
    func getCurrentTime() -> String {
        let currentTime:CMTime = (player.currentItem?.currentTime())!
        let current:TimeInterval = CMTimeGetSeconds(currentTime)
        if current.isNaN == true {
            return "00:00"
        }
        let currentInt:Int = Int(current)
        return String.init(format: "%.2d:%.2d", currentInt/60,currentInt%60)
    }
    
    func getDuration() -> String {
        let durationTime:CMTime = (player.currentItem?.duration)!
        let duration:TimeInterval = CMTimeGetSeconds(durationTime)
        if duration.isNaN == true {
            return "00:00"
        }
        let durationInt:Int = Int(duration)
        return String.init(format: "%.2d:%.2d", durationInt/60,durationInt%60)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            switch self.playerItem.status {
            case .readyToPlay:
                self.player.play();
                break;
            case .unknown:
                break;
            case .failed:
                break;
            @unknown default:
                break;
            }
        } else {
            
        }
        
    }
    
    @objc func mvFullScreen() -> Void {
        fullScreen = !fullScreen;
        if fullScreen {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(showOperation), object: nil);
            playerView.isHidden = true;
            CATransaction.begin();
            CATransaction.setDisableActions(false);
            bgView.layer.setAffineTransform(CGAffineTransform.init(rotationAngle: CGFloat(Double.pi/2)));
            bgView.layer.bounds = CGRect.init(x: 0, y: 0, width: SCREEN_HEIGHT, height: SCREEN_WIDTH);
            bgView.layer.position = CGPoint.init(x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT/2)
            avLayer.setAffineTransform(CGAffineTransform.init(rotationAngle: CGFloat(Double.pi/2)));
            avLayer.bounds = CGRect.init(x: 0, y: 0, width: SCREEN_HEIGHT, height: SCREEN_WIDTH);
            avLayer.position = CGPoint.init(x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT/2)
            CATransaction.commit();
            if player.rate == 0 {
                fullPlayerView.isHidden = false;
            }
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(showOperation), object: nil);
        } else {
            fullPlayerView.isHidden = true
            CATransaction.begin();
            CATransaction.setDisableActions(false);
            bgView.layer.setAffineTransform(CGAffineTransform.init(rotationAngle: 0));
            bgView.layer.bounds = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH/640*360);
            bgView.layer.position = CGPoint.init(x: SCREEN_WIDTH/2, y: SCREEN_WIDTH/640*360/2)
            avLayer.setAffineTransform(CGAffineTransform.init(rotationAngle: 0));
            avLayer.bounds = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH/640*360);
            avLayer.position = CGPoint.init(x: SCREEN_WIDTH/2, y: SCREEN_WIDTH/640*360/2)
            CATransaction.commit();
            if player.rate == 0 {
                playerView.isHidden = false;
            }
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(showOperation), object: nil);
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        player.pause();
        avLayer.player = nil;
        self.navigationController?.setNavigationBarHidden(false, animated: true);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(true, animated: true);
    }
    
    override var prefersStatusBarHidden: Bool {
        return true;
    }
    
}
