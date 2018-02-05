//
//  HomeViewCell.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/5.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit
import SDWebImage

// 边距
private let cellEdgeMargin: CGFloat = 15

class HomeViewCell: UITableViewCell {

    //MARK:- 约束属性
    @IBOutlet weak var contentLabelWidthConstraint: NSLayoutConstraint!
    
    //MARK:- UI属性
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    //MARK:- ViewModel
    var viewModel: StatusViewModel? {
        didSet{
            // 值校验
            guard let viewModel = viewModel else {
                return
            }
            
            // UI设定
            iconView.sd_setImage(with: viewModel.iconUrl, placeholderImage: UIImage(named: "avatar_default_small"))
            verifiedView.image = viewModel.verifiedImage
            nameLabel.text = viewModel.status?.user?.screen_name
            vipView.image = viewModel.vipImage
            timeLabel.text = viewModel.createAtText
            sourceLabel.text = viewModel.sourceText
            contentLabel.text = viewModel.status?.text
        }
    }
    
    //MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置微博正文的宽度约束
        contentLabelWidthConstraint.constant = UIScreen.main.bounds.width - 2*cellEdgeMargin
    }

}


