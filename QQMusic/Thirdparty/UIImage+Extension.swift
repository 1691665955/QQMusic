//
//  UIImage+Extension.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/23.
//  Copyright © 2019 com.mz. All rights reserved.
//

import Foundation
import UIKit
extension UIImage {
    class func getImageWithColor(color:UIColor) -> UIImage {
        let frame = CGRect.init(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(frame.size);
        let context = UIGraphicsGetCurrentContext();
        context?.setFillColor(color.cgColor);
        context?.fill(frame);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!;
    }
}
