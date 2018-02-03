//
//  WellcomeViewController.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/3.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit
import SDWebImage

class WellcomeViewController: UIViewController {

    @IBOutlet weak var iconView: UIImageView!
    /// 底部距离约束
    @IBOutlet weak var iconViewBottomContraints: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlStr = UserAccountTool.shareInstance.account?.avatar_large
        // 使用位移枚举的时候，如果不想传值，可以使用空数组
        iconView.sd_setImage(with: URL(string: urlStr ?? ""), placeholderImage: UIImage(named: "avatar_default_big"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 头像动画
        iconViewBottomContraints.constant = UIScreen.main.bounds.height - 200
        
        // 弹簧动画
        // damping:阻力系数， 0~1 ，越大弹簧效果越小
        // SpringVelocity: 初始速度
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            //            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }) { (_) in
            // 创建Main
            // 不能直接创建Main，而要从storyBoard中加载
            UIApplication.shared.keyWindow?.rootViewController = MainViewController.loadFromStoryBoard()
        }
    }

    

}
