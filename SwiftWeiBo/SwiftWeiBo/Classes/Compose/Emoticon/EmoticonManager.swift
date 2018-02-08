//
//  EmoticonManager.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/8.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit

class EmoticonManager {

    lazy var packages: [EmoticonPackage] = [EmoticonPackage]()
    
    //MARK:- 构造函数, 加载所有的表情包EmoticonPackage
    init() {
        // 最近表情
        packages.append(EmoticonPackage(id: ""))
        
        // 默认表情
        packages.append(EmoticonPackage(id: "com.sina.default"))
        
        // emoji表情
        packages.append(EmoticonPackage(id: "com.apple.emoji"))
        
        // 浪小花表情
        packages.append(EmoticonPackage(id: "com.sina.lxh"))
    }
    
}
