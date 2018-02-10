//
//  PhotoBrowserCell.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/10.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoBrowserCell: UICollectionViewCell {
    
    //MARK:- 属性
    var picUrl: URL? {
        didSet{
            guard let picUrl = picUrl else {
                return
            }
            
            // 1.取出图片
            guard let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picUrl.absoluteString) else {
                return
            }
            // 2.计算imageView的尺寸
            let x: CGFloat = 0.0
            let width = contentView.bounds.width
            let height = image.size.height * width / image.size.width
            var y: CGFloat = 0.0
            if height > contentView.bounds.height {
                y = 0.0
            } else {
                y = (contentView.bounds.height - height) * 0.5
            }
            imageView.frame = CGRect(x: x, y: y, width: width, height: height)
            imageView.image = image
        }
    }
    
    //MARK:- lazy属性
    fileprivate lazy var scrollView: UIScrollView = UIScrollView()
    fileprivate lazy var imageView: UIImageView = UIImageView()
    
    //MARK:- 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension PhotoBrowserCell {
    fileprivate func setupUI() {
        contentView.addSubview(scrollView)
        contentView.addSubview(imageView)
        
        scrollView.frame = contentView.bounds
    }
}
