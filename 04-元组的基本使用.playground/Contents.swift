//: Playground - noun: a place where people can play

import UIKit

// 使用三种数据类型来存储一组数据，用户信息（name，age， height）
// 1.数组存储数据
let array = ["xx", 20, 1.88] as [Any]
array[0]
array[1]

// 2.字典存储数据
let dict = ["name":"xx", "age":20, "height":1.88] as [String : Any]
dict["name"]
dict["age"]

// 3.使用元祖存储数据
let info = ("xx", 20, 1.88)
info.0
info.1

let info1 = (name:"xx", age:20, height:1.88)
info1.name
info1.age

let (name, age, height) = ("xx", 20, 1.88)
name
age





