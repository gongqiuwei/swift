//
//  UIBarButtonItem-Extension.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /// 使用imagename直接生成UIBarButtonItem
    convenience init(imageName: String) {
        let btn = UIButton()
        btn.setImage(UIImage(named:imageName), for: .normal)
        btn.setImage(UIImage(named:imageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        
        // 便利构造函数，需要显示调用其他已经存在的init构造函数
        self.init(customView: btn)
    }
    
}
