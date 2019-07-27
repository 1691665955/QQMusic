//
//  MZCircleProgress.swift
//  MyFirstSwiftProject
//
//  Created by 曾龙 on 17/3/30.
//  Copyright © 2017年 scinan. All rights reserved.
//

import UIKit

class MZCircleProgress: UIView {
    
    var backLineWidth:CGFloat!      //底条宽度
    var progressLineWidth:CGFloat!  //进度条宽度
    var backLineColor:UIColor!      //底条颜色
    var progressLineColor:UIColor!  //进度条颜色
    var startAngle:CGFloat!         //开始弧度
    var endAngle:CGFloat!           //结束弧度
    var textLabel:UILabel!          //中间文本框
    //比例（0-1）
    var ratio:CGFloat!{
        didSet {
            if ratio<0 {
                ratio = 0
            } else if ratio>1 {
                ratio = 1
            }
            
            if self.lineLayer != nil{
                self.lineLayer.strokeEnd = ratio
            }
        }
    }
    var lineLayer:CAShapeLayer!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUI() {
        let textLabel = UILabel.init()
        self.textLabel = textLabel
        textLabel.textColor = UIColor.black
        textLabel.textAlignment = NSTextAlignment.center
        self.addSubview(textLabel)
        
        self.backLineColor = UIColor.lightGray
        self.backLineWidth = 6
        self.progressLineColor = UIColor.blue
        self.progressLineWidth = 6
        self.textLabel.font = UIFont.systemFont(ofSize: 60)
        self.textLabel.textColor = UIColor.blue
        self.ratio = 0
        self.startAngle = -CGFloat(Double.pi/2)
        self.endAngle = CGFloat(Double.pi/2)+CGFloat(Double.pi)

    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let radio = ((self.frame.size.width < self.frame.size.height ? self.frame.size.width : self.frame.size.height) - (self.backLineWidth > self.progressLineWidth ? self.backLineWidth : self.progressLineWidth)) * 0.5;
        let path = UIBezierPath.init()
        let centerPoint = CGPoint.init(x: self.bounds.size.width*0.5, y: self.bounds.size.height*0.5)
        path.addArc(withCenter: centerPoint, radius: radio, startAngle: self.startAngle, endAngle: self.endAngle, clockwise: true)
        
        let backLayer = CAShapeLayer.init()
        backLayer.frame = self.bounds
        backLayer.fillColor = UIColor.clear.cgColor
        backLayer.lineWidth = self.backLineWidth
        backLayer.strokeColor = self.backLineColor.cgColor
        backLayer.strokeStart = 0
        backLayer.strokeEnd = 1
        backLayer.path = path.cgPath
        self.layer.addSublayer(backLayer)
        
        let lineLayer = CAShapeLayer.init()
        lineLayer.frame = self.bounds
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.lineWidth = self.progressLineWidth
        lineLayer.strokeColor = self.progressLineColor.cgColor
        lineLayer.strokeStart = 0
        lineLayer.strokeEnd = self.ratio
        lineLayer.path = path.cgPath
        self.lineLayer = lineLayer
        self.layer.addSublayer(lineLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.textLabel.frame = CGRect.init(x: 0, y: 0, width: self.bounds.size.width*0.8, height: self.bounds.size.height*0.5)
        self.textLabel.center = CGPoint.init(x: self.bounds.size.width*0.5, y: self.bounds.size.height*0.5)
    }
    
}
