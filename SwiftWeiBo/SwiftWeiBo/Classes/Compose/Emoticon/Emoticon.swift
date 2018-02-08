//
//  Emoticon.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/8.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//  单个表情模型

import UIKit

class Emoticon: NSObject {

    //MARK:- 属性
    var code: String?       // emoji的code
    var png: String?        // 普通表情对应的图片名称
    var chs : String?       // 普通表情对应的文字
    
    //MARK:- 构造函数
    init(dict: [String:String]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    // 模型的自定义打印
    // 打印方法 print(String(reflecting:emoticon))
    override var debugDescription: String {
        return dictionaryWithValues(forKeys: ["code", "png", "chs"]).debugDescription
    }
}
