//: Playground - noun: a place where people can play

import UIKit

// 1.dictionary的定义和初始化
// let定义不可变，var定义可变
let dict = ["name": "xx", "age" : 20] as [String : Any]

// NSObject, AnyObject, Any区别??
var dict1 = [String : Any]()
dict1["age"] = 20
dict1["age"]

// 增删改查
dict1["height"] = 1.88

dict1.removeValue(forKey: "height")
dict1

dict1.updateValue(200, forKey: "age")
dict1["age"] = 300;

dict1["age"]


// 遍历
for key in dict.keys{
    print(key)
}

for value in dict.values{
    print(value)
}

for (key, value) in dict{
    print("key:\(key), value:\(value)")
}

// 字典合并
// 不能使用+进行合并
var dict2 = ["1":"str1"]
var dict3 = ["2":"str2"]
for (key, value) in dict2{
    dict3[key] = value
}
dict3






