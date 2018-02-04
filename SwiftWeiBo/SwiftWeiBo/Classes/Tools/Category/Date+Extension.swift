//
//  Date+Extension.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/4.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import Foundation

extension Date {
    // static, class: 类型方法
    // static子类无法重写实现， class子类可以重写
    // createAt样式:"Sun Feb 04 19:50:03 +0800 2018"
    static func createAtText(from createAt:String) -> String {
        
        // 1.根据str创建date
        let fmt = DateFormatter()
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        fmt.locale = Locale(identifier: "en") // 将时间转为0时区
        
        guard let createDate = fmt.date(from: createAt) else {
            return ""
        }
        
        // 2.和当前时间比较
        let nowDate = Date()
        
        // 2.1 如果在1分钟以内，刚刚
        let interVal = Int(nowDate.timeIntervalSince(createDate)) // 返回单位是s
        if interVal < 60 {
            return "刚刚"
        }
        
        // 2.2 如果在1小时以内，xx分钟前
        if interVal < 60 * 60 {
            return "\(interVal/60)分钟前"
        }
        
        // 2.3 如果在24小时内，xx小时前
        if interVal < 24 * 60 * 60 {
            return "\(interVal/(60*60))小时前"
        }
        
        // 2.4 如果在昨天内：昨天 03:24
        let calendar = Calendar.current
        if calendar.isDateInYesterday(createDate) {
            fmt.dateFormat = "HH:mm"
            let timeStr = fmt.string(from: createDate)
            return "昨天 \(timeStr)"
        }
        
        // 2.5 一年内: 02-23 03:24
        let result = calendar.dateComponents([.year], from: createDate, to: nowDate)
        if result.year! < 1 {
            fmt.dateFormat = "MM-dd HH:mm"
            return fmt.string(from: createDate)
        }
        
        // 2.6 一年后: 2015-2-23 03:23
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        return fmt.string(from: createDate)
    }
}
