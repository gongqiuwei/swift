//
//  ProgressView.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/26.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    var progress: CGFloat = 0.0 {
        didSet {
            // 会调用draw方法重新绘制
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print("progress: \(progress)")
        // 1.绘制圆弧
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let radius = rect.width*0.5 - 3
        let startAngle = CGFloat(-M_PI_2)
        let endAngle = CGFloat(2*M_PI) * progress + startAngle
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        // 2.绘制到中心点的线
        path.addLine(to: center)
        
        // 3.闭合曲线
        path.close()
        
        // 4.设置填充绘制的颜色
        UIColor(white: 0.0, alpha: 0.4).setFill()
        
        // 5.path填充
        path.fill()
    }
}
