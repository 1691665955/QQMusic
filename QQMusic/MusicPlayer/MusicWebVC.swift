//
//  MusicWebVC.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/13.
//  Copyright © 2019 com.mz. All rights reserved.
//

import UIKit
import WebKit

class MusicWebVC: UIViewController {

    var url:String!
    var webView:WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        
        let webView = WKWebView.init(frame: CGRect.init(x: 0, y: Navi_Height, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-Navi_Height));
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil);
        webView.load(URLRequest.init(url: URL.init(string: self.url)!));
        self.view.addSubview(webView);
        self.webView = webView;
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title" {
            self.title = self.webView.title;
        }
    }
    
}
