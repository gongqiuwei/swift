//: Playground - noun: a place where people can play

import UIKit

/*
 函数基本格式：
 func 函数名 (参数列表) -> 返回值类型{
    代码块
    return 返回值
 }
 */

// 1. 无参数无返回值
func about() -> Void {
    print("iPhone7")
}
about()

func about1() -> (){
    print("iPhone7")
}
about1()

func about2() {
    print("iPhone7")
}

// 2.有参数无返回值
func callPhone(phoneNum: String){
    print("打电话给" + phoneNum)
}
callPhone(phoneNum: "110")

// 3.无参数有返回值
func readMessage() -> String {
    return "吃了吗？"
}
print(readMessage())

// 4.有参数有返回值
func sum(num1:Int, num2:Int) -> Int {
    return num1 + num2
}
sum(num1: 10, num2: 12)

// 5.函数使用注意
// 5.1指定参数标签（有参数标签后，addNum2 代替了 num2）
func sum1(num1:Int, addNum2 num2:Int) -> Int {
    return num1 + num2
}
//sum1(num1: 11, num2: 1)
sum1(num1: 1, addNum2: 2)

// 5.2忽略参数标签 (_ 表示忽略，num1在调用时可以不写)
func sum2(_ num1:Int, addNum2 num2:Int) -> Int {
    return num1 + num2
}
sum2(1, addNum2: 2)

// 5.3默认参数
func drink(name:String = "水") {
    print("喝" + name)
}
drink(name: "可乐")
drink()

// 5.4可变参数
func sum3(num:Int ...) -> Int { // num成为一个存储参数的数组
    var result = 0
    for n in num {
        result += n
    }
    return result
}
sum3(num: 1,2,3)

// 5.5inout参数(相当于指针传递)
// 函数参数默认是常量。试图在函数体中更改参数值将会导致编译错误(compile-time error)。这意味着你不能错 误地更改参数值。如果你想要一个函数可以修改参数的值，并且想要在这些修改在函数调用结束后仍然存在，那 么就应该把这个参数定义为输入输出参数(In-Out Parameters)
// 定义一个输入输出参数时，在参数定义前加 inout 关键字。一个输入输出参数有传入函数的值，这个值被函数 修改，然后被传出函数，替换原来的值。
// 你只能传递变量给输入输出参数。你不能传入常量或者字面量，因为这些量是不能被修改的。当传入的参数作为 输入输出参数时，需要在参数名前加 & 符，表示这个值可以被函数修改。
// 注意 输入输出参数不能有默认值，而且可变参数不能用 inout 标记

var num1 = 20
var num2 = 30

// 注意点 
// 1>如果不声明为inout 在函数内部，参数num1是let 常量，无法更改
// 2>swap(&num1, &num2) 传入的num1 num2必须是var 不能是let常量
func swapNum(num1: inout Int, num2: inout Int){
    let tempNum = num1
    num1 = num2
    num2 = tempNum
}
swap(&num1, &num2)
num1
num2

// 不想使用inout，需要在函数内部使用变量
func useParam(num: Int) {
    var tempNum = num
    tempNum = 800
    print(tempNum, num)
}
useParam(num: 100)
