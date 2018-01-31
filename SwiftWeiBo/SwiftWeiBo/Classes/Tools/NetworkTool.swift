//
//  NetworkTool.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/1/31.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import AFNetworking

/*
 枚举类型：
 */
enum RequestType : String {
    case get = "GET"
    case post = "POST"
}

class NetworkTool: AFHTTPSessionManager {
    
    /*
     iOS实现单例模式的方法：
     1> 通过shareXXX或者defaultXXX拿到的永远是同一个对象
     2> 不管通过何种方法，得到的永远是同一个对象
     
     OC中以上2中都采用过，swift中使用第一种方法非常便利
     */
    // 使用static类型属性常量来实现单例模式。。。。
    static let shareInstance : NetworkTool = {
        let tool = NetworkTool()
        
        tool.responseSerializer.acceptableContentTypes?.insert("text/html")
        
        return tool
    }()
    
    /*
     测试http的网站：http://httpbin.org 发送哪个请求，将请求的数据封装返回
     */
    func request(withType requestType: RequestType,urlString: String, parameters: Any?, finishedCallBack:((_ result: Any?, _ error: Error?)->())?){
//        get(urlString, parameters: parameters, progress: nil, success: { (task:URLSessionDataTask, result: Any?) in
//            print(result ?? "没有返回数据")
//        }) { (task: URLSessionDataTask?, error: Error) in
//            print(error)
//        }
        
        // 成功回调
        let sucessCallBack = { (task:URLSessionDataTask, result:Any?) in
            
            if let finishedCallBack = finishedCallBack {
                finishedCallBack(result, nil)
            }
        }
        
        // 失败回调
        let failureCallBack = { (task:URLSessionDataTask?, error:Error) in
            if let finishedCallBack = finishedCallBack {
                finishedCallBack(nil, error)
            }
        }
        
        // 发送请求
        switch requestType {
        case .get:
            get(urlString, parameters: parameters, progress: nil, success: sucessCallBack, failure: failureCallBack)
        case .post:
            post(urlString, parameters: parameters, progress: nil, success: sucessCallBack, failure: failureCallBack)
        }
        
    }
}
