//: Playground - noun: a place where people can play

import UIKit

/* OC和Swift中字符串的区别
1 在OC中字符串类型时NSString,在Swift中字符串类型是String
2 OC中字符串@"",Swift中字符串""
 */

/* swift中的String
 String 是一个结构体，性能更高
 NSString 是一个 OC 对象，性能略差
 String 支持直接遍历
 Swift 提供了 String 和 NSString 之间的无缝转换
 */
// 1. 基本使用
var str = "hello world"

for c in str.characters{ // 字符
    print(c)
}

// 2.字符串拼接
// 2.1 两个字符串的拼接
let str1 = "hello"
let str2 = "world"
let str3 = str1 + str2

// 2.2 字符串和其他数据类型的拼接
let name = "xx"
let age = 20
let str4 = "my name is \(name), my age is \(age)"

// 2.3 字符串的格式化 如 03：04
let min = 3
let second = 4
let str5 = String(format: "%02d:%02d", min, second)
let str6 = String(format: "%02d:%02d", arguments: [min, second])

// 3. 字符串截取
// swift中字符串截取比较麻烦，一般转成NSString进行操作
let url = "www.baidu.com"
var subUrl = (url as NSString).substring(to: 3)
subUrl = (url as NSString).substring(with: NSMakeRange(4, 5))
subUrl = (url as NSString).substring(from: 10)

