//
//  MessageViewController.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/1/26.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit

class MessageViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        visitorView.setupVisitorViewInfo(title: "登录后，别人评论你的微博，给你发消息，都会在这里收到通知", iconName: "visitordiscover_image_message")
    }

}
