//
//  StatusViewModel.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/5.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//  将status和user的处理方法封装到这里

import UIKit

class StatusViewModel: NSObject {

    var status: Status?
    
    // MARK:- 自己附加处理属性
    var sourceText: String?
    var createAtText: String?
    var verifiedImage: UIImage?
    var vipImage: UIImage?
    var iconUrl: URL?
    var picUrls: [URL] = [URL]()
    
    init(status:Status) {
        self.status = status
        
        // 1. 处理sourcetext
        // 判断输入的数据
        // 多重guard判断，swift3.0之前用where， swift3.0用 ， 隔开
        // 相当于先guard let source = source else{},
        // 然后guard source != "" else{}
        if let source = status.source, source != "" {
            // 1.查找 "> 的位置
            // 2.查找 </ 的位置
            let beginIndex = (source as NSString).range(of: "\">").location + 2
            let length = (source as NSString).range(of: "</").location - beginIndex
            sourceText = (source as NSString).substring(with: NSRange(location: beginIndex, length: length))
        }
        
        // 2. 处理createAtText
        if let create_at = status.created_at {
            createAtText = Date.createAtText(from: create_at)
        }
        
        // 3. 处理verifiedImage
        let verifiedType = status.user?.verified_type ?? -1
        switch verifiedType {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2, 3, 5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        
        // 4. 处理vipImage
        let mbrank = status.user?.mbrank ?? 0
        if mbrank>0 && mbrank<7 {
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        
        // 5.处理iconUrl
        let iconUrlStr = status.user?.profile_image_url ?? ""
        iconUrl = URL(string: iconUrlStr)
        
        // 6.处理picUrls, 当有转发时保存转发，没有转发时保存原创
        // 是否有转发？如何判断
        // count 为 Int? , 可以与 Int 进行 == , != 比较
        let count = status.pic_urls?.count
        let picUrlsDict = count != 0 ?  status.pic_urls : status.retweeted_status?.pic_urls
        
        if let pic_urls = picUrlsDict {
            for picDict in pic_urls {
                guard let urlStr = picDict["thumbnail_pic"] else {
                    continue
                }
                
                //thumbnail_pic是不清晰的图片，将urlStr中的/thumbnail/替换为/bmiddle/就是清晰的，sina的锅
                let tempstr = urlStr.replacingOccurrences(of: "/thumbnail/", with: "/bmiddle/")
                // 保证传入的urlstring能够生成一个url，因为
                let url = URL(string: tempstr)!
                picUrls.append(url)
            }
        }
    }
    
}
