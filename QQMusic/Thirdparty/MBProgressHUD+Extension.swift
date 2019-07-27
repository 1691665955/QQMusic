//
//  MBProgressHUD+Extension.swift
//  diary
//
//  Created by 曾龙 on 2018/7/20.
//  Copyright © 2018年 mz. All rights reserved.
//

import Foundation
import MBProgressHUD
extension MBProgressHUD {
    static func showSuccess(success:String!) {
        self.show(text: success);
    }
    
    static func showError(error:String!) {
        self.show(text: error);
    }
    
    static func showMessage(message:String?) {
        let view = self.getWindowView();
        let hud = MBProgressHUD.showAdded(to: view, animated: true);
        hud.detailsLabel.text = message;
        hud.removeFromSuperViewOnHide = true;
        hud.backgroundView.style = MBProgressHUDBackgroundStyle.solidColor;
        hud.backgroundView.color = UIColor.init(white: 0, alpha: 0.1);
    }
    
    static func hideHUD() {
        let view = self.getWindowView();
        self.hide(for: view, animated: true);
    }
    
    private static func getWindowView() -> UIView{
        let app = UIApplication.shared
        if (app.delegate?.responds(to: #selector(getter: window)))! {
            return ((app.delegate?.window)!)!;
        } else {
            return app.keyWindow!;
        }
    }
    
    private static func show(text:String) {
        let view = self.getWindowView();
        let hud = MBProgressHUD.showAdded(to: view, animated: true);
        hud.detailsLabel.text = text;
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 17);
        hud.mode = MBProgressHUDMode.customView;
        hud.removeFromSuperViewOnHide = true;
        hud.hide(animated: true, afterDelay: 2.0);
    }
}
