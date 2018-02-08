//
//  EmoticonPackage.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/8.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//  一个表情包，即是Emoticons.bundle下的某个文件里面info.plist管理的文件数据

import UIKit

class EmoticonPackage: NSObject {

    lazy var emoticons: [Emoticon] = [Emoticon]()
    
    //MARK:- 构造函数
    /// 根据id确定不同的表情包
    init(id: String) {
        super.init()
        
        // 值判断， ""为最近表情
        if id == "" {
            return
        }
        
        // 根据id获取info.plist的全路径
        guard let emoticonPath = Bundle.main.path(forResource: "\(id)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle") else {
            // 可以在这里使用断言，断言要加载的表情包不存在
            return
        }
        
        // 加载文件, Array无法从文件加载，NSArray才有这个功能
        // oc中NSString、NSArray、NSDictionary等可以无缝转换到swift
        guard let array = ( NSArray(contentsOfFile: emoticonPath)  as? [[String:String]]) else {
            // 来到这里说明info.plist文件格式不对
            return
        }
        
        // 遍历，转换成Emoticon模型
        for dict in array {
            emoticons.append(Emoticon(dict: dict))
        }
        
    }
}
