//
//  ComposeTextView.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/7.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//  带提示文字的textView

import UIKit
import SnapKit

class ComposeTextView: UITextView {
    
    fileprivate lazy var placeHolderLabel: UILabel = UILabel()
    
    // 从xib或者storyboard文件中创建
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
}

extension ComposeTextView {
    fileprivate func setupUI() {
        addSubview(placeHolderLabel)
        
        placeHolderLabel.textColor = UIColor.lightGray
        placeHolderLabel.font = font
        placeHolderLabel.text = "分享新鲜事..."
        
        placeHolderLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.top.equalTo(7)
        }
        
        // 设置textView的内边距
        textContainerInset.left = 7
        textContainerInset.right = 7
    }
}
