//
//  PhotoBrowserController.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/10.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit

class PhotoBrowserController: UIViewController {
    
    //MARK:- 属性
    var picUrls: [URL]
    var indexPath: IndexPath
    
    //MARK:- 构造函数
    init(picUrls: [URL], indexPath: IndexPath) {
        
        self.picUrls = picUrls
        self.indexPath = indexPath
        
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.purple
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
}
