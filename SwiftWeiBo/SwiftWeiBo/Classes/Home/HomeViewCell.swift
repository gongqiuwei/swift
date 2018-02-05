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
// 图片item之间的距离
private let itemMargin: CGFloat = 10

class HomeViewCell: UITableViewCell {

    //MARK:- 约束属性
    @IBOutlet weak var contentLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var picViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var picViewWidthConstraint: NSLayoutConstraint!
    
    //MARK:- UI属性
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var picView: UICollectionView!
    
    
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
            
            // 设置picView
            let picSize = caculatePicViewSize(count: viewModel.picUrls.count)
            picViewHeightConstraint.constant = picSize.height
            picViewWidthConstraint.constant = picSize.width
        }
    }
    
    //MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置微博正文的宽度约束
        contentLabelWidthConstraint.constant = UIScreen.main.bounds.width - 2*cellEdgeMargin
    }

}

//MARK:- 计算方法
extension HomeViewCell {
    fileprivate func caculatePicViewSize(count: Int) -> CGSize {
        // 0个
        if count == 0 {
            return CGSize.zero
        }
        
        
        let picW = UIScreen.main.bounds.width - 2*cellEdgeMargin
        let imageWH = (picW - 2*itemMargin) / 3 // 假设图片为正方形
        // 四个
        if count == 4 {
            let picWH = imageWH * 2 + itemMargin
            return CGSize(width: picWH, height: picWH)
        }
        
        // 单个
        
        // 其他情况
        let rows = CGFloat((count - 1) / 3 + 1)  // 九宫格算法
        let picH = rows * imageWH + (rows-1) * itemMargin
        return CGSize(width: picW, height: picH)
    }
}
