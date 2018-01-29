//
//  ProfileViewController.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/1/26.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        visitorView.setupVisitorViewInfo(title: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人", iconName: "visitordiscover_image_profile")
    }
    
}
