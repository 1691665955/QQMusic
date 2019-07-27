//
//  MZMarqueeLabel.swift
//  MyFirstSwiftProject
//
//  Created by 曾龙 on 17/4/7.
//  Copyright © 2017年 scinan. All rights reserved.
//

import UIKit

class MZMarqueeLabel: UIView {
    var label1:UILabel!
    var label2:UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUI() {
        self.clipsToBounds = true
    }
    
    func setBackgroundColr(backgroundColr:UIColor,text:String,font:UIFont,textColor:UIColor,textAlignment:NSTextAlignment) {
        
        if self.label1 != nil {
            self.label1.removeFromSuperview()
            self.label2.removeFromSuperview()
            self.label1 = nil
            self.label2 = nil
        }
        
        self.label1 = UILabel.init()
        self.label1.backgroundColor = UIColor.clear
        self.addSubview(self.label1)
        
        self.label2 = UILabel.init()
        self.label2.backgroundColor = UIColor.clear
        self.addSubview(self.label2)
        
        self.backgroundColor = backgroundColor
        self.label1.text = text
        self.label1.font = font
        self.label1.textColor = textColor
        self.label1.textAlignment = textAlignment
        
        self.label2.text = String.init(format: "   %@   ", text)
        self.label2.font = font
        self.label2.textColor = textColor
        self.label2.textAlignment = textAlignment
        
        self.label1.frame = self.bounds
        self.label2.frame = CGRect.init(x: self.bounds.size.width, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        
        let maxSize = CGSize.init(width:CGFloat.greatestFiniteMagnitude , height: self.bounds.size.height )
        let size1 = self.label1.sizeThatFits(maxSize)
        let size2 = self.label2.sizeThatFits(maxSize)
    
        if size1.width>self.bounds.size.width {
            self.label1.frame = CGRect.init(x: 0, y: 0, width: size1.width, height: self.bounds.size.height)
            self.label2.frame = CGRect.init(x: size1.width, y: 0, width: size2.width, height: self.bounds.size.height)
            self.updateLabelFrame()
        }
    }
    
    func updateLabelFrame() {
        UIView.animate(withDuration: 10, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
            var frame1 = self.label1.frame
            var frame2 = self.label2.frame
            frame1.origin.x =  frame1.origin.x-(frame1.size.width+frame2.size.width)*0.5
            self.label1.frame = frame1
            frame2.origin.x =  frame2.origin.x-(frame1.size.width+frame2.size.width)*0.5
            self.label2.frame = frame2
            }) { (completion) in
                if completion == true {
                    if self.label1.frame.maxX <= 0 {
                        self.label1.frame = CGRect.init(x: self.label2.frame.maxX, y: 0, width: self.label1.frame.size.width, height: self.label1.frame.size.height)
                    } else if self.label2.frame.maxX <= 0 {
                        self.label2.frame = CGRect.init(x: self.label1.frame.maxX, y: 0, width: self.label2.frame.size.width, height: self.label2.frame.size.height)
                    }
                    self.updateLabelFrame()
                }
        }
    }
    

}
