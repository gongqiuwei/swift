//
//  PicCollectionView.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/5.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit
import SDWebImage

class PicCollectionView: UICollectionView {
    
    var picUrls: [URL] = [URL]() {
        didSet{
            reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
        delegate = self
    }
}

extension PicCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePicCellId", for: indexPath) as! PicCollectionCell
        cell.imageUrl = picUrls[indexPath.item]
        
        return cell
    }
    
    /// 点击了图片的某个cell，通知HomeViewController
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 发送通知
        NotificationCenter.default.post(name: Notification.Name(PhotoBrowserShouldShowNotification), object: self, userInfo: [PhotoBrowserIndexKey: indexPath, PhotoBrowserUrlKey: picUrls])
    }
}

//MARK:- PhotoBrowserAnimatorPresentDelegate
extension PicCollectionView: PhotoBrowserAnimatorPresentDelegate {
    // 开始的frame
    func startRectForPresent(indexPath: IndexPath) -> CGRect {
        // 根据indexPath取出cell
        let cell = cellForItem(at: indexPath)!
        
        // cell的frame是相对于它的父控件，也就是collectionview的位置，需要转换到相对于keywindow
        let rect = self.convert(cell.frame, to: UIApplication.shared.keyWindow)
        
        return rect
    }
    // 结束的frame
    func endRectForPresent(indexPath: IndexPath) -> CGRect {
        // 取出image
        let url = picUrls[indexPath.item]
        let urlStr = url.absoluteString
        guard let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: urlStr) else {
            return CGRect.zero
        }
        
        // 根据image确定尺寸,类似PhotoBrowserCell中的计算
        let x: CGFloat = 0.0
        let width = UIScreen.main.bounds.width
        let height = image.size.height * width / image.size.width
        var y: CGFloat = 0.0
        if height > UIScreen.main.bounds.height {
            y = 0.0
        } else {
            y = (UIScreen.main.bounds.height - height) * 0.5
        }
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func imageViewForPresent(indexPath: IndexPath) -> UIImageView {
        // 取出image
        let url = picUrls[indexPath.item]
        let urlStr = url.absoluteString
        let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: urlStr)
        
        // 创建imageView
        let imageView = UIImageView(image: image)
        // Mode属性和PicCollectionCell中的一致
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
}


//MARK:-PicCollectionCell
class PicCollectionCell: UICollectionViewCell {
    
    var imageUrl:URL? {
        didSet{
            iconView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    
    @IBOutlet weak var iconView: UIImageView!
}


