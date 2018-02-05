//
//  User.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/4.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit

class User: NSObject {

    // MARK:- 属性
    var profile_image_url : String?         // 用户的头像
    var screen_name : String?               // 用户的昵称
    // 用户的认证类型
    var verified_type : Int = -1
//    var verified_type : Int = -1 {
//        didSet {
//            switch verified_type {
//            case 0:
//                verifiedImage = UIImage(named: "avatar_vip")
//            case 2, 3, 5:
//                verifiedImage = UIImage(named: "avatar_enterprise_vip")
//            case 220:
//                verifiedImage = UIImage(named: "avatar_grassroot")
//            default:
//                verifiedImage = nil
//            }
//        }
//    }
    // 用户的会员等级
    var mbrank : Int = 0
//    var mbrank : Int = 0 {
//        didSet {
//            if mbrank>0 && mbrank<7 {
//                vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
//            }
//        }
//    }
    
    // MARK:- 自定义属性，对用户数据处理
    var verifiedImage : UIImage?
    var vipImage : UIImage?
    
    // MARK:- 自定义构造函数
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict) 
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
