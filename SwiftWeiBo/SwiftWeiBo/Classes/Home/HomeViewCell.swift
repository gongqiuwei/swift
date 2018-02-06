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
    @IBOutlet weak var retweetedContentLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var picViewBottomConstraint: NSLayoutConstraint!
    
    //MARK:- UI属性
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var picView: PicCollectionView!
    @IBOutlet weak var retweetedContentLabel: UILabel!
    @IBOutlet weak var retweetedBgView: UIView!
    @IBOutlet weak var bottomToolView: UIView!
    
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
            contentLabel.text = viewModel.status?.text
            if let sourceText = viewModel.sourceText {
                sourceLabel.text = "来自" + sourceText
            } else {
                sourceLabel.text = nil
            }
            
            // 设置picView
            let picSize = caculatePicViewSize(count: viewModel.picUrls.count)
            picViewHeightConstraint.constant = picSize.height
            picViewWidthConstraint.constant = picSize.width
            
            picView.picUrls = viewModel.picUrls
            
            // 判断是否有转发微博
            if let retweetedStatus = viewModel.status?.retweeted_status{
                if let screenName = retweetedStatus.user?.screen_name, let retweetedText = retweetedStatus.text {
                    retweetedContentLabel.text = "@ \(screenName): " + retweetedText
                }
                
                retweetedBgView.isHidden = false
                // 有转发微博的时候，距离上面需要15的间距
                retweetedContentLabelTopConstraint.constant = 15
                
            } else {
                retweetedContentLabel.text = nil
                retweetedBgView.isHidden = true
                
                // 没有转发微博的时候，距离上面不需要间距
                retweetedContentLabelTopConstraint.constant = 0
            }
            
            
            // 手动计算cell的高度
            // 适用AutoLayout强制刷新布局
            layoutIfNeeded()
            
            viewModel.cellHeight = bottomToolView.frame.maxY
        }
    }
    
    //MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        picView.isScrollEnabled = false
        
        // 设置微博正文的宽度约束
        contentLabelWidthConstraint.constant = UIScreen.main.bounds.width - 2*cellEdgeMargin
    }

}

//MARK:- 计算方法
extension HomeViewCell {
    fileprivate func caculatePicViewSize(count: Int) -> CGSize {
        // 0个
        if count == 0 {
            
            // 没有配图的时候调整picView约束
            picViewBottomConstraint.constant = 0
            
            return CGSize.zero
        }
        
        // 有配图的时候调整picView约束
        picViewBottomConstraint.constant = 10
        
        let picW = UIScreen.main.bounds.width - 2*cellEdgeMargin
        let imageWH = (picW - 2*itemMargin) / 3 // 假设图片为正方形
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = itemMargin
        layout.minimumLineSpacing = itemMargin
        
        // 单个(由于接口没有返回图片的width和height比例，需要先下载好图片后，在进行处理, )
        if count == 1 {
            let urlStr = viewModel?.picUrls.last?.absoluteString
            if let image = SDImageCache.shared().imageFromDiskCache(forKey: urlStr) {
                
                // 单张图片的宽高规则：先简单设定为
                // 根据图片w：h比例，让w和h都限制在 picW 以内
                
                // 获取图片的比例
                var tempW = image.size.width
                var tempH = image.size.height
                if image.size.width >= image.size.height { // 图片比较宽
                    if image.size.width > picW { // 范围外，width需要处理
                        tempW = picW-itemMargin
                        tempH = tempW * image.size.height / image.size.width
                    }
                } else { // 图片比较高
                    if image.size.height > picW {
                        tempH = picW-itemMargin
                        tempW = tempH * image.size.width / image.size.height
                    }
                }
                
                layout.itemSize = CGSize(width: tempW, height: tempH)
                // 返回的时候多加一点，不然可能报出警告：the item width must be less than the width of the UICollectionView minus the section insets left and right values, minus the content insets left and right values.
                return CGSize(width: tempW+2, height: tempH+2)
            }
        }
        
        // 设置其他情况picView的itemsize
        layout.itemSize = CGSize(width: imageWH, height: imageWH)
        
        // 四个
        if count == 4 {
            // 会出现像素不足的情况，一般向上取整或者+1像素
            let picWH = imageWH * 2 + itemMargin + 1
            return CGSize(width: picWH, height: picWH)
        }
        
        // 其他情况
        let rows = CGFloat((count - 1) / 3 + 1)  // 九宫格算法
        // 会出现像素不足的情况，一般向上取整或者+1像素
        let picH = rows * imageWH + (rows-1) * itemMargin + 1
        return CGSize(width: picW, height: picH)
        
        /*
         计算宽度和高度的时候需要注意，很可能会少1个像素，导致可以collectionview可以滑动，导致无法拖动tableview的cell，因此在计算的时候需要特别注意，或者取消collectionview的滑动功能
         */
    }
}
