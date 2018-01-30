//
//  UIButton-Extension.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/1/28.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit

/*
 小结：
 方法扩充：
    swift中，创建对象，推荐使用构造函数，而不是像OC中使用类方法
    例如：UIImage
        [UIImage imageName:imageName]; // OC
        UIImage(name:imageName); // swift
 */

extension UIButton {
    
    /// 类方法扩充
    // swift中类方法是以class开头的方法.类似于OC中+开头的方法
    class func createBtn(imageName:String, bgImageName:String) -> UIButton {
        let btn = UIButton()
        
        btn.setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        btn.setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: .highlighted)
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        
        // 设置位置尺寸
        // 设置好图片后，可以使用这个方法让按钮尺寸进行自适应
        btn.sizeToFit()
        
        return btn
    }
    
    
    // extension里面无法设计init构造函数，只能声明便利构造函数，需要加convenience
    /*
     便利构造函数
     使用convenience修饰的构造函数叫做便利构造函数
     便利构造函数通常用在对系统的类进行构造函数的扩充时使用
     
     遍历构造函数的特点
     1.遍历构造函数通常都是写在extension里面
     2.遍历构造函数init前面需要加载convenience
     3.在遍历构造函数中需要明确的调用self.init()
     */
    convenience init(imageName:String, bgImageName:String) {
        // 调用self.init,或者提供的其他构造函数，显示调用
        self.init()
        
        // 属性设置
        setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: .highlighted)
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        
        // 设置好图片后，可以使用这个方法让按钮尺寸进行自适应
        sizeToFit()
    }
    
}
