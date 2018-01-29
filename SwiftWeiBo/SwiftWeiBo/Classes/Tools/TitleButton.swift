//
//  TitleButton.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit

class TitleButton: UIButton {

    // 不能重写init方法，UI控件一般重写init(frame:)方法
    // UI控件的init方法内部会调用init(frame:)
    override init(frame: CGRect) {
        // 先使用super 生成对象，在对对象的属性进行设定，要在显示调用
        super.init(frame: frame)
        
        setImage(UIImage(named:"navigationbar_arrow_down"), for: .normal)
        setImage(UIImage(named:"navigationbar_arrow_up"), for: .selected)
        setTitleColor(UIColor.black, for: .normal)
        sizeToFit()
        
        // 去除高亮状态图片变暗
        adjustsImageWhenHighlighted = false
    }
    
    // swift中规定:重写控件的init(frame方法)或者init()方法,必须重写init?(coder aDecoder: NSCoder)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel!.frame.origin.x = 0
        imageView!.frame.origin.x = titleLabel!.frame.size.width + 5
    }
}
