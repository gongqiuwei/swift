//
//  VisitorView.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/1/28.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    /// 快速创建VisitorView，从xib中加载
    class func visitorView() -> VisitorView {
        
        let view = Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)?.last as! VisitorView
        
        return view
    }
    
    
    @IBOutlet weak var rotationView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    
    /// 设置visitorview信息
    func setupVisitorViewInfo(title:String, iconName:String) {
        iconView.image = UIImage(named: iconName)
        tipLabel.text = title
        rotationView.isHidden = true
    }
    
    // 添加旋转动画 coreanimation
    func addRotation() {
        
        // 动画是围绕z轴旋转
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        
        // 设置属性
        rotationAnim.fromValue = 0
        rotationAnim.toValue = M_PI * 2
        rotationAnim.duration = 7
        rotationAnim.repeatCount = MAXFLOAT
        // 动画完成后不移除，默认true
        // true会造成切换页面切换后再切回来动画效果就被移除掉了
        rotationAnim.isRemovedOnCompletion = false
        
        // 添加动画
        rotationView.layer.add(rotationAnim, forKey: nil)
    }
}
