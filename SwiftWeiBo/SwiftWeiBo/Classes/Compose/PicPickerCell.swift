//
//  PicPickerCell.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/7.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit

class PicPickerCell: UICollectionViewCell {

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closeBtn: UIButton!
    
    var image: UIImage? {
        didSet{
            if let image = image {
                imageView.isHidden = false
                imageView.image = image
                closeBtn.isHidden = false
                addBtn.isUserInteractionEnabled = false
                
            } else {
                imageView.isHidden = true
                imageView.image = nil
                closeBtn.isHidden = true
                addBtn.isUserInteractionEnabled = true
            }
        }
    }

    /// 添加照片按钮点击
    @IBAction func addPhotoClicked() {
        /// 通知ComposeViewController添加照片
        NotificationCenter.default.post(name: NSNotification.Name( PicPickerViewAddPhotoNotification), object: nil)
    }
    
    /// 删除照片点击
    @IBAction func closeClicked() {
        /// 通知ComposeViewController删除照片
        NotificationCenter.default.post(name: NSNotification.Name(PicPickerViewRemovePhotoNotification), object: image)
    }
    
}
