//
//  HomeViewController.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/1/26.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit


class HomeViewController: BaseViewController {

    //MARK: - 懒加载属性
    fileprivate lazy var titleButton : TitleButton = TitleButton()
    // 注意:在闭包中如果使用当前对象的属性或者调用方法,也需要加self
    // 两个地方需要使用self : 1> 如果在一个函数中出现歧义 2> 在闭包中使用当前对象的属性和方法也需要加self
    fileprivate lazy var popoverAnimator : PopoverAnimator = PopoverAnimator(presentedFrame : CGRect(x: 100, y: 55, width: 180, height: 250), callBack:{ [weak self] (isPresented) in
        self?.titleButton.isSelected = isPresented
    })
    
    fileprivate lazy var statuses:[Status] = [Status]()
    
    //MARK: - 系统周期函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 没有登录状态下
        guard isLogin else {
            // 添加旋转动画
            visitorView.addRotation()
            return;
        }
        
        // 登录状态下
        setupNavgationBar()
        loadStatus()
    }

    /*
    // 测试网络工具类
 
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        NetworkTool.shareInstance.request(withType: .post, urlString: "http://httpbin.org/post", parameters: ["name" : "xxx", "age" : 18]) { (result:Any?, error:Error?) in
            if let error = error {
                print(error)
                return
            }
            
            print(result ?? "没有返回数据")
        }
        
    }
     */
}

//MARK:- UI设定
extension HomeViewController {
    /// 设置导航栏
    fileprivate func setupNavgationBar() {
        /*
        let leftBtn = UIButton()
        leftBtn.setImage(UIImage(named:"navigationbar_friendattention"), for: .normal)
        leftBtn.setImage(UIImage(named:"navigationbar_friendattention_highlighted"), for: .highlighted)
        leftBtn.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
         */
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        titleButton.setTitle("iOSCoder", for: .normal)
        titleButton.addTarget(self, action: #selector(HomeViewController.titleBtnClicked(sender:)), for: .touchUpInside)
        navigationItem.titleView = titleButton
    }
}


//MARK:- 事件处理
extension HomeViewController {
    
    @objc fileprivate func titleBtnClicked(sender: TitleButton) {
        
        let popover = PopoverViewController()
        // 设置custom的目的是使后面的tabbarcontroller不会消失， 默认会移除
        popover.modalPresentationStyle = .custom
        popover.transitioningDelegate = popoverAnimator
        
        present(popover, animated: true, completion: nil)
    }
}

//MARK:- 网络请求
extension HomeViewController {
    fileprivate func loadStatus() {
        NetworkTool.shareInstance.loadStatus { (result:[[String : Any]]?, error:Error?) in
            if let error = error {
                print(error, "loadStatus请求错误")
                return
            }
            
            guard let resultArr = result  else{
                return
            }
            
            // 字典转模型
            for dict in resultArr {
                let status = Status(with: dict)
                self.statuses.append(status)
            }
            
            self.tableView.reloadData()
        }
    }
}


//MARK:- tableView代理方法
extension HomeViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCellID")!
        
        let status = statuses[indexPath.row]
        cell.textLabel?.text = status.text
        
        return cell
    }
}
