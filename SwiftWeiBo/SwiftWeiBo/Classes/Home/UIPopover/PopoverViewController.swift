//
//  PopoverViewController.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }

}
