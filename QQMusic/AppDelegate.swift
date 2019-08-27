//
//  AppDelegate.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/7/26.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow()
        self.window?.frame = UIScreen.main.bounds
        self.window?.makeKeyAndVisible()
        
        let musicMainVC = MusicMainVC()
        let nav = MZNavigationController.init(rootViewController: musicMainVC);
        let tabVC = MusicTabbarController()
        tabVC.addChild(nav)
        self.window?.rootViewController = tabVC
        
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true;
        IQKeyboardManager.shared().isEnableAutoToolbar = false;
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        return true
    }

    override func remoteControlReceived(with event: UIEvent?) {
        let manager = MZMusicPlayerManager.shareManager
        switch event!.subtype {
        case UIEventSubtype.remoteControlPlay:
            manager.play()
            break
        case UIEventSubtype.remoteControlPause:
            manager.pause()
            break
        case UIEventSubtype.remoteControlNextTrack:
            manager.playNextMusic()
            break
        case UIEventSubtype.remoteControlPreviousTrack:
            manager.playPreMusic()
            break
        case UIEventSubtype.remoteControlTogglePlayPause:
            if manager.musicPlayer.rate == 0 {
                manager.play()
            } else {
                manager.pause()
            }
            break
        default:
            break
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        UserDefaults.standard.setValue("1", forKey: "backGround")
        UserDefaults.standard.synchronize()
        
        print("resignActive")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("EnterBackground")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("EnterForeground")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UserDefaults.standard.setValue("0", forKey: "backGround")
        UserDefaults.standard.synchronize()
        
        print("becomeActive")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        let manager = MZMusicPlayerManager.shareManager
        if manager.currentTime != nil {
            UserDefaults.standard.set(manager.currentTime, forKey: "currentTime")
            UserDefaults.standard.set(manager.playIndex, forKey: "playIndex")
            let musicListData = NSKeyedArchiver.archivedData(withRootObject: manager.playerItemList as Any)
            UserDefaults.standard.set(musicListData, forKey: "musicList")
            UserDefaults.standard.synchronize()
            print("terminate")
        }
        
        let databaseManager = MusicDatabaseManager.share
        databaseManager.database.close()
    }
}

