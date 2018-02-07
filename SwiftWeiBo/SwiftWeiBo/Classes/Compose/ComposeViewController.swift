//
//  ComposeViewController.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/7.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    fileprivate lazy var titleView: ComposeTitleView = ComposeTitleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavItem()
    }

}

extension ComposeViewController {
    fileprivate func setupNavItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(ComposeViewController.closeItemClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(ComposeViewController.sendItemClicked))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        navigationItem.titleView = titleView
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
    }
    
    @objc private func closeItemClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func sendItemClicked() {
        print("sendItemClicked")
    }
}


