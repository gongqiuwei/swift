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
    
    var code: String?{       // emoji的code
        didSet{
            guard let code = code else {
                return
            }
            
            // 对emoji的string进行转换
            // 1. 对string进行扫描
            let scanner = Scanner(string: code)
            // 2. 获取对应的值
            var value: UInt32 = 0
            scanner.scanHexInt32(&value)
            // 3. 转成Character
            let scalar = UnicodeScalar(value)
            let c = Character(scalar!)
            // 4. 转成string
            emojiCode = String(c)
        }
    }
    
    var png: String?{        // 普通表情对应的图片名称
        didSet{
            // 设置的png图片名称无法直接使用，因为不是放在mainBundle中，因此需要全路径
            guard let png = png else {
                return
            }
            
            let bundlePath = Bundle.main.path(forResource: "Emoticons.bundle", ofType: nil)!
            
            // bundlePath + (id文件名称) + png，这里无法获取到，在package中对png添加
            pngPath = bundlePath + "/" + png
        }
    }
    var chs: String?       // 普通表情对应的文字
    
    var pngPath: String?    // 图片全路径
    var emojiCode: String?  // emoji对用的字符
    var isRemove: Bool = false  // 是否是删除键
    var isEmpty: Bool = false   // 是否是空白表情
    
    //MARK:- 构造函数
    init(dict: [String:String]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    init(isRemove: Bool) {
        self.isRemove = isRemove
    }
    init(isEmpty: Bool) {
        self.isEmpty = isEmpty
    }
    
    // 模型的自定义打印
    // 打印方法 print(String(reflecting:emoticon))
    override var debugDescription: String {
        return dictionaryWithValues(forKeys: ["emojiCode", "pngPath", "chs"]).debugDescription
    }
}
