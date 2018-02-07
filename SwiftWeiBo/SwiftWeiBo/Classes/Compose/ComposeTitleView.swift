//
//  ComposeTitleView.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/7.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTitleView: UIView {

    fileprivate lazy var titleLabel: UILabel = UILabel()
    fileprivate lazy var screenNameLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ComposeTitleView {
    fileprivate func setupUI() {
        addSubview(titleLabel)
        addSubview(screenNameLabel)
        
        // 布局
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        screenNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(2)
        }
        
        // 设置
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        screenNameLabel.font = UIFont.systemFont(ofSize: 13)
        screenNameLabel.textColor = UIColor.lightGray
        
        titleLabel.text = "发微博"
        screenNameLabel.text = UserAccountTool.shareInstance.account?.screen_name
    }
}


