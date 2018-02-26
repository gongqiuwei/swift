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
            setContent(picUrl: picUrl)
        }
    }
    
    //MARK:- lazy属性
    fileprivate lazy var scrollView: UIScrollView = UIScrollView()
    lazy var imageView: UIImageView = UIImageView()
    fileprivate lazy var progressView: ProgressView = ProgressView()
    
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
        contentView.addSubview(progressView)
        scrollView.addSubview(imageView)
        
        scrollView.frame = contentView.bounds
        scrollView.frame.size.width -= 20
        
        progressView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: UIScreen.main.bounds.width*0.5, y: UIScreen.main.bounds.height*0.5)
        progressView.backgroundColor = UIColor.clear
        progressView.isHidden = true
    }
}

//MARK:- 图片处理
extension PhotoBrowserCell {
    
    fileprivate func setContent(picUrl: URL?) {
        guard let picUrl = picUrl else {
            return
        }
        
        // 1.取出图片
        guard let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picUrl.absoluteString) else {
            return
        }
        
        setContentWithImage(image: image)
        
        // 4.设置image
        progressView.isHidden = false
        imageView.sd_setImage(with: getBigUrl(smallUrl: picUrl), placeholderImage: image, options: [], progress: { (current, total, _) in
            // 注意点1: 这个block是在后台线程中执行的
            // print("\(Thread.current)")
            DispatchQueue.main.async {
                // 注意点2: total的值可能为-1
                if total > 0 {
                    // print("current: \(current), total: \(total)")
                    self.progressView.progress = CGFloat(current) / CGFloat(total)
                }
            }
        }) { (image, _, _, _) in
            self.progressView.isHidden = true
            
            // 重新计算尺寸
            guard let image = image else {
                return
            }
            
            self.setContentWithImage(image: image)
        }
    }
    
    fileprivate func getBigUrl(smallUrl: URL) -> URL? {
        let urlStr = smallUrl.absoluteString
        let tempstr = urlStr.replacingOccurrences(of: "/thumbnail/", with: "/bmiddle/")
        
        return URL(string: tempstr)
    }
    
    fileprivate func setContentWithImage(image: UIImage) {
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
        
        // 3.设置scrollView的content
        scrollView.contentSize = CGSize(width: 0, height: height)
    }
    
}



