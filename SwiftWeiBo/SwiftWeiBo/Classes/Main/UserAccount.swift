//
//  UserAccount.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/1/31.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {

    /// 授权AccessToken
    var access_token : String?
    /// 过期时间，单位秒
    var expires_in : TimeInterval = 0.0 {
        didSet {
            expire_date = Date(timeIntervalSinceNow: expires_in)
        }
    }
    /// 用户id
    var uid : String?
    /// 过期日期，由于过期时间不好比较，因此扩展一个属性
    var expire_date : Date?
    
    /// 用户昵称
    var screen_name : String?
    /// 用户头像(大图)
    var avatar_large : String?
    
    /// 构造方法
    init(dict:[String:Any]){
        super.init()
        
        setValuesForKeys(dict)
    }
    /// 保证有未定义的key时候不会崩溃
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    
    // swift中，自定义NSObject的打印，需要重写debugDescription或者descriotion
    // 前提是遵守CustomDebugStringConvertible协议
    // 为了方便程序调试，在模型对象中，建议重写 description 属性
    override var debugDescription: String{
        return dictionaryWithValues(forKeys: ["access_token", "expires_in", "uid", "screen_name", "avatar_large"]).debugDescription
    }
    
    //MARK:- NSCoding
    /// 归档
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        expire_date = aDecoder.decodeObject(forKey: "expire_date") as? Date
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
    }
    
    /// 解档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expire_date, forKey: "expire_date")
        aCoder.encode(screen_name, forKey: "screen_name")
        aCoder.encode(avatar_large, forKey: "avatar_large")
    }
}

