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

// 类似于OC的typedef
typealias FinishedNetCallBack = (_ result:[String:Any]?, _ error:Error?)->()

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
    fileprivate func request(withType requestType: RequestType,urlString: String, parameters: Any?, finishedCallBack:((_ result: Any?, _ error: Error?)->())?){
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

//MARK:- 具体api调用
extension NetworkTool{
    func loadAccessToken(byCode code:String, finished:@escaping FinishedNetCallBack){
        
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let parameters = ["client_id":app_key, "client_secret": app_secret, "grant_type":"authorization_code", "code":code, "redirect_uri":redirect_uri]
        
        request(withType: .post, urlString: urlString, parameters: parameters) { (result: Any?, error : Error?) in
            finished(result as? [String:Any], error)
        }
    }
    
    func loadUserInfo(byToken accessToken: String, uid : String, finished: @escaping FinishedNetCallBack) {
        let urlString = "https://api.weibo.com/2/users/show.json"
        let parameters = ["access_token" : accessToken, "uid" : uid]
        
        request(withType: .get, urlString: urlString, parameters: parameters) { (result:Any?, error:Error?) in
            finished(result as? [String:Any], error)
        }
    }
    
    func loadStatus(since_id: Int, max_id: Int, finished:@escaping (_ result:[[String:Any]]?, _ error:Error?)->()) {
        
        let urlStr = "https://api.weibo.com/2/statuses/home_timeline.json"
        let paramaters = ["access_token":(UserAccountTool.shareInstance.account?.access_token)!, "since_id": since_id, "max_id": max_id] as [String:Any]
        
        // print("paramaters: \(paramaters)")
        
        request(withType: .get, urlString: urlStr, parameters: paramaters) { (result:Any?, error:Error?) in
            
            // 对result进行处理后返回
            let resultDict = result as? [String:Any]
            let statusesArr = resultDict?["statuses"]
            finished(statusesArr as? [[String:Any]], error)
            
            // print(statusesArr ?? "空值")
        }
        
    }
}
