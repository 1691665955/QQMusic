//
//  MZBase.swift
//  diary
//
//  Created by 曾龙 on 2018/6/20.
//  Copyright © 2018年 mz. All rights reserved.
//

import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height


//适配iPhoneX
let isIPhoneX = (UIScreen.main.bounds.height >= 812.0)
let Navi_Height = CGFloat(UIScreen.main.bounds.height >= 812.0 ? 88.0: 64.0)
let StateBar_Height = CGFloat(UIScreen.main.bounds.height >= 812.0 ? 44.0: 20.0)
let Tabbar_Height = CGFloat(UIScreen.main.bounds.height >= 812.0 ? 83.0: 49.0)
let Safe_Bottom = CGFloat(UIScreen.main.bounds.height >= 812.0 ? 34.0: 0)

func RGBA(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) -> UIColor {
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

func RGB(r:CGFloat,g:CGFloat,b:CGFloat) -> UIColor {
    return RGBA(r: r, g: g, b: b, a: 1)
}

