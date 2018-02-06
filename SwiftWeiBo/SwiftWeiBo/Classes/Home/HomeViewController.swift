//
//  HomeViewController.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/1/26.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

class HomeViewController: BaseViewController {

    //MARK: - 懒加载属性
    fileprivate lazy var titleButton : TitleButton = TitleButton()
    // 注意:在闭包中如果使用当前对象的属性或者调用方法,也需要加self
    // 两个地方需要使用self : 1> 如果在一个函数中出现歧义 2> 在闭包中使用当前对象的属性和方法也需要加self
    fileprivate lazy var popoverAnimator : PopoverAnimator = PopoverAnimator(presentedFrame : CGRect(x: 100, y: 55, width: 180, height: 250), callBack:{ [weak self] (isPresented) in
        self?.titleButton.isSelected = isPresented
    })
    
//    fileprivate lazy var statuses:[Status] = [Status]()
    fileprivate lazy var viewModels:[StatusViewModel] = [StatusViewModel]()
    
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
        
        // tableView设定
        // 当需要AutoLayout自动计算高度的时候添加这个
        // tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        setupHeader()
    }
}

//MARK:- UI设定
extension HomeViewController {
    /// 设置刷新控件
    fileprivate func setupHeader() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadNewStatus))
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放更新", for: .pulling)
        header?.setTitle("加载中...", for: .refreshing)
        
        tableView.mj_header = header
        tableView.mj_header.beginRefreshing()
    }
    
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
    @objc fileprivate func loadNewStatus() {
        loadStatus(isNewData:true)
    }
    
    
    fileprivate func loadStatus(isNewData: Bool) {
        
        var since_id = 0
        if isNewData {
            since_id = viewModels.first?.status?.mid ?? 0
        }
        
        NetworkTool.shareInstance.loadStatus(since_id: since_id) { (result:[[String : Any]]?, error:Error?) in
            if let error = error {
                print(error, "loadStatus请求错误")
                return
            }
            
            guard let resultArr = result  else{
                return
            }
            
            // 字典转模型
            var tempViewModels = [StatusViewModel]()
            for dict in resultArr {
                let status = Status(with: dict)
                let viewModel = StatusViewModel(status: status)
//                self.viewModels.append(viewModel)
                tempViewModels.append(viewModel)
            }
            
            // 当前的viewmodels
            self.viewModels = tempViewModels + self.viewModels
            
            // 缓存图片数据(为了单张图片)
//            self.cacheImages(viewModels: self.viewModels)
            self.cacheImages(viewModels: tempViewModels)
        }
    }
    
    private func cacheImages(viewModels:[StatusViewModel]) {
        
        // DispatchGroup组
        let group = DispatchGroup()
        
        for viewModel in viewModels {
            for picUrl in viewModel.picUrls {
                // 开始下载前进入group
                group.enter()
                // 开始下载图片
                SDWebImageDownloader.shared().downloadImage(with: picUrl, options: [], progress: nil, completed: { (_, _, _, _) in
                    // print("保存一张图片")
                    // 下载完成后离开group
                    group.leave()
                })
            }
        }
        
        // 等待图片全部下载完成，reloaddata
        group.notify(queue: DispatchQueue.main) { 
            // print("下载完成")
            self.tableView.reloadData()
            
            self.tableView.mj_header.endRefreshing()
        }
    }
}


//MARK:- tableView代理方法
extension HomeViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCellID") as! HomeViewCell
        
        cell.viewModel = viewModels[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 获取viewModel
        let viewModel = viewModels[indexPath.row]
        
        return viewModel.cellHeight
    }
}
