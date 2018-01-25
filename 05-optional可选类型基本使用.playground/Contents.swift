//: Playground - noun: a place where people can play

import UIKit

// 1.为什么要使用可选类型
// swift中用可选类型用来处理值可能缺失的情况 optional
// 有值：xxx  没有值：nil
class Person:NSObject{
    var name:String? // name初始化的时候可能没有值
}

// 2.初始化、赋值
// 基本使用
//var name:Optional<String> = nil
// 语法糖
var name:String?
name = "xxxxx"

// 因为打印出来的是可选类型,所有会带Optional
print(name)
//print(name ?? "空")

// 3.强制解包
// 从可选类型中取值:可选类型!-->强制解包
print(name!)

// 强制解包是一个很危险的行为，因为name很可能为nil，会导致崩溃
// 强制解包前需要判断是否为空
var str:String?
str = "test"
if str != nil {
    print(str!)
}

// 4.可选绑定（为了解决强制解包带来的麻烦，代码繁琐）
// 可选绑定做了2件事：
// 1> 判断是否为nil，不为空执行{}内代码，为空跳过
// 2> 如果有值,则对可选类型进行解包,并且将解包后的值赋值给前面的常量
var str1:String?
if let tempStr1 = str1 {
    print(tempStr1)
}

// 可选绑定常用的写法
var str3:String? = "str3"
if let str3 = str3 {
    print(str3)
}


// 5. 实际应用
// 创建一个request
//let url = NSURL(string: "http://www.baidu.com/测试")
let url = NSURL(string: "http://www.baidu.com")
url
// 强制解包很危险
//let request = NSURLRequest(url: url as! URL)

if let url = url {
    let request = NSURLRequest(url: url as URL)
}
