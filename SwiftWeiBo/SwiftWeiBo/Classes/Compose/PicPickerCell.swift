//
//  PicPickerCell.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/7.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit

class PicPickerCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    /// 添加照片按钮点击
    @IBAction func addPhotoClicked() {
        NotificationCenter.default.post(name: NSNotification.Name( PicPickerViewAddPhotoNotification), object: nil)
    }
}
