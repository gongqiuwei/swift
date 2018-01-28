//
//  MainViewController.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/1/26.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit

// storyboard方式初始化主界面
class MainViewController: UITabBarController {
    
    fileprivate lazy var composeBtn : UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupComposeBtn()
    }
}

extension MainViewController {
    fileprivate func setupComposeBtn() {
        tabBar.addSubview(composeBtn)
        
        // 设置属性
        composeBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), for: .normal)
        composeBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), for: .highlighted)
        composeBtn.setImage(UIImage(named: "tabbar_compose_icon_add"), for: .normal)
        composeBtn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), for: .highlighted)
        
        // 设置位置尺寸
        // 设置好图片后，可以使用这个方法让按钮尺寸进行自适应
        composeBtn.sizeToFit()
        
        // swift中结构体的创建，使用init构造函数
        //        composeBtn.center = CGPointMake(tabBar.center.x, tabBar.bounds.size.height*0.5)
        composeBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height*0.5)
    }
}

/* 
// 通过纯代码的方式创建控制器
class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        addChildViewControllerFromJsonFile()
        
        // 全局设置tabbar的tincolor（tincolor影响选中图片和选中文字颜色）
//        UITabBar.appearance().tintColor = UIColor.orange
        
        // 添加字控制器
//        addChildViewController(childVcName:"HomeViewController", title: "首页", imageName: "tabbar_home")
//        addChildViewController(childVcName:"MessageViewController", title: "消息", imageName: "tabbar_message_center")
//        addChildViewController(DiscoverViewController(), title: "发现", imageName: "tabbar_discover")
//        addChildViewController(ProfileViewController(), title: "我", imageName: "tabbar_profile")
    }

    /// 通过jsondata文件配置
    private func addChildViewControllerFromJsonFile() {
        // 1.获取json文件路径
        guard let filePath = Bundle.main.path(forResource: "MainVCSettings.json", ofType: nil) else {
            print("filepath failure")
            return;
        }
        
        guard let jsonData = NSData(contentsOfFile: filePath) as? Data else {
            return
        }
//        guard let fileUrl = Bundle.main.url(forResource: "MainVCSettings.json", withExtension: nil) else {
//            return
//        }
//        
//        guard let jsonData = try? Data.init(contentsOf: fileUrl) else {
//            return
//        }
        
        
        // 2.序列化json数据
        /* 异常捕捉的方式
         1. try方式
         do {
         let anyObject = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
         } catch {
         print(error)
         }
         2. try?方式
         3. try!方式
         */
        guard let anyObject = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) else {
            return;
        }
        
        guard let dictArr = anyObject as? [[String:String]] else {
            return;
        }
        
        for dict in dictArr {
            guard let childVcName = dict["vcName"] else {
                continue
            }
            
            guard let title = dict["title"] else {
                continue
            }
            
            guard let imageName = dict["imageName"] else {
                continue
            }
            
            addChildViewController(childVcName: childVcName, title: title, imageName: imageName)
        }
    }
    
    
    /// 通过类名添加子控制器
    private func addChildViewController(childVcName: String, title: String, imageName: String) {
        guard let childVc = viewController(forName: childVcName) else {
            return;
        }
        childVc.tabBarItem.title = title
        childVc.tabBarItem.image = UIImage(named: imageName)
        childVc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        
        let nav = UINavigationController(rootViewController: childVc)
        addChildViewController(nav)
    }
    
    /// 通过类名创建控制器
    private func viewController(forName vcName:String ) -> UIViewController? {
        // 直接使用类名无法生成class，原因在与swift的命名空间namespace
        // print(self)
        
        // 1.获取命名空间名称(target中的类命名空间就是当前项目名称，当然如果在xcode中设定就不一样了，这个待研究)
        // http://blog.csdn.net/chengkaizone/article/details/50533858
        // swift3.0 NSBundle改为Bundle
        guard let infoDict = Bundle.main.infoDictionary else {
            // 获取不到infodict
            return nil
        }
        
        guard let namespace = infoDict["CFBundleExecutable"] as? String else {
            // CFBundleExecutable的值取不到
            return nil
        }
        
        let vcClassName = namespace + "." + vcName
        guard let vcClass = NSClassFromString(vcClassName) else {
            // 生成vcClass失败
            return nil
        }
        
        // 根据class创建对象
        // https://mp.weixin.qq.com/s?__biz=MzIzMzA4NjA5Mw==&mid=213993163&idx=1&sn=95cf79bed2707961ec1a6c17c9103d8a&scene=18#rd
        guard let vcClassType = vcClass as? UIViewController.Type else {
            return nil
        }
        
        let vc = vcClassType.init()
        
        return vc
    }
    
    // swift支持方法的重载
    // 方法的重载:方法名称相同,但是参数不同. --> 1.参数的类型不同 2.参数的个数不同
    // private：访问控制，只有当前类能访问(swift3.0之后当前文件的extension 也不能访问)
    // fileprivate: 当前文件能访问
    private func addChildViewController(_ childVc: UIViewController, title: String, imageName: String) {
        
        // setTitleTextAttributes设置字体等属性
        childVc.tabBarItem.title = title
        childVc.tabBarItem.image = UIImage(named: imageName)
        childVc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        
        let nav = UINavigationController(rootViewController: childVc)
        addChildViewController(nav)
    }
    
    func test(){
//        addChildViewController(<#T##childVc: UIViewController##UIViewController#>, title: <#T##String#>, imageName: <#T##String#>)
    }

}

extension MainViewController {
    func test1(){
        addChildViewController(UIViewController())
//        addChildViewController(<#T##childVc: UIViewController##UIViewController#>, title: <#T##String#>, imageName: <#T##String#>)
    }
}


//class Person: NSObject {
//    func test2(){
//        let main = MainViewController()
//        main.addChildViewController(UIViewController())
//    }
//}
*/
