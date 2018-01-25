//: Playground - noun: a place where people can play

import UIKit

// swift中数组是一个泛型集合
// 1.初始化、定义

// 1.1 let定义不可变数组，var定义可变数组
let array = ["1111", "2222", "3333"]
let array1 : [String]
let array2:Array<String>

var arrayM = [String]()
var arrayM1:[String] = []

// 2.数组的基本操作
// 2.1 添加元素
arrayM.append("11")
arrayM.insert("44", at: 0)
arrayM.append("22")
arrayM.append("33")

// 2.2删除
arrayM.remove(at: 0)
//arrayM.removeLast()
//arrayM.removeFirst()
//arrayM.removeAll()

// 2.3取值与修改
let str1 = arrayM[0]
//let strs = arrayM[0..<2]
arrayM[0..<2] = ["test1", "test2"]
arrayM
arrayM[2] = "test3"
arrayM

// 3.数组遍历
for i in 0..<array.count{
    print(array[i])
}

for str in array{
    print(str)
}
//for str in array[0...2]{
//    print(str)
//}

for (index, value) in array.enumerated(){
    print("index:\(index) value:\(value)")
}


// 4.数组合并
// 注意，只有array的类型一致才能相加合并
let strArray1 = ["11", "22"]
let strArray2 = ["33", "44"]
let strArray = strArray1 + strArray2

// 遍历合并
var strArray3 = strArray1
for str in strArray2 {
    strArray3.append(str)
}
strArray3

