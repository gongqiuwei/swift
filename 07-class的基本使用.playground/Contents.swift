//: Playground - noun: a place where people can play

import UIKit

/*
 1. class的基本使用
    1> 类的定义 （可以有父类，也可以没有父类）
    2> 创建类对应的对象 
        如：Person()
    3> 对象属性的赋值 
        直接赋值/使用KVC
    4> 方法重写
        重写父类的方法，需要加override
 */

class People {
    var age : Int = 0
}

let po = People()
po.age = 20 // 由于People不是继承自NSObject，没有kvc特性



class Person : NSObject {
    var age : Int = 0
    
    // 重写, 如果写的某一个方法是对父类的方法进行的重写,那么必须在该方法前加上override
    // 使用KVC的时候，当某个属性没有定义的时候，会调用这个方法，如果不重写NSObject的这个方法，默认崩溃
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}

let p = Person()
p.age = 20
p.age

// setValuesForKeysWithDictionary swift2.2
p.setValuesForKeys(["age":18])
p.age

p.setValuesForKeys(["age":22, "name":"xxx"])
p.age


/*
 2.类的属性 
    1> 存储属性
    2> 计算属性
    3> 类属性
    4> 属性监听器
 */
class Student : NSObject {
    // 存储属性定义，同时必须初始化赋值，
    // 如果初始化值为nil，需要使用Optional类型
    var age : Int = 0
    var name : String?
    
    var mathScore : Double = 0.0
    var chineseScore : Double = 0.0
    
    // 计算属性: 通过别的方式计算到结果的属性,称之为计算属性
    var averageScore : Double {
        return (mathScore + chineseScore) * 0.5
    }
    // OC没有计算属性，这种情况时一般是使用一个方法，现在swift又计算属性了，建议使用计算属性
    func getAverageScore() -> Double {
        return (mathScore + chineseScore) * 0.5
    }
    
    // 类属性是和整个类相关的属性.而且是通过类名进行访问
    static var courseCount : Int = 0
    func getCourseCount() -> Int {
        return Student.courseCount
    }
    
    // 属性监听器
    var className : String? {
        // 属性值即将发生改变的时候调用
        willSet{
            print(className)
            // 系统自带的一个临时局部变量，即将设定的值存储在newValue中
            print(newValue)
        }
        
        // 属性值已经发生改变的时候调用
        didSet{
            print(className)
            print(oldValue)
        }
    }
}

let s = Student()
s.age = 10
s.name = "xxxx"
print(s.age)
if let name = s.name {
    print(name)
}

s.mathScore = 80
s.chineseScore = 58.5
print(s.averageScore, s.getAverageScore())

Student.courseCount = 2
print(Student.courseCount)
print(s.getCourseCount())

s.className = "test1";
s.className = "test2"
/*
 3.类的构造函数
 构造函数类似于OC中的初始化方法:init方法
 默认情况下载创建一个类时,必然会调用一个构造函数
 即便是没有编写任何构造函数，编译器也会提供一个默认的构造函数。
 如果是继承自NSObject,可以对父类的构造函数进行重写
    1>默认构造函数 类似于init()
    2>自定义构造函数
    3>重写父类构造函数
 */

class Animal : NSObject {
    var name : String?
    var age : Int = 0
    
    override init() {
        // 在构造函数中,如果没有明确super.init(),那么系统会帮助调用super.init()
        // super.init()
        print("-----")
    }
    
    // 自定义构造函数
    init(name:String, age:Int) {
        // 必须是使用self，不然取不到当前对象的name属性
        self.name = name
        self.age = age
    }
    
    init(dict:[String : Any]){
        // tempName: 取出来的类型是 Any? , 与name类型Sring? 不一致，无法直接赋值
        let tempName = dict["name"]
        // as? 最终转成的类型是一个可选类型
        // as! 最终转成的类型是一个确定的类型
        let tempName1 = tempName as? String
        if let tempName2 = tempName1 {
            name = tempName2;
        }
        
        if let tempAge = dict["age"] as? Int {
            age = tempAge
        }
    }
    
    //KVC赋值
    init(keyValues : [String : Any]) {
        // super.init()不主动调用的话，会在最后面调用
        // super.init()还未调用之前，super的方法无法使用
        super.init()
        setValuesForKeys(keyValues)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}

let a = Animal()
let a1 = Animal(name: "11", age: 10)
print(a1.name!, a1.age)

let a2 = Animal(dict: ["name" : "22", "age" : 10])
print(a2.name ?? "空", a2.age)

let a3 = Animal(keyValues: ["name" : "33", "age" : 13, "height":1.11])
print(a3.name ?? "空", a3.age)


