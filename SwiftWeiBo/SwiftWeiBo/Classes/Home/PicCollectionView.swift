//
//  PicCollectionView.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/5.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit

class PicCollectionView: UICollectionView {
    
    var picUrls: [URL] = [URL]() {
        didSet{
            reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
    }
}

extension PicCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePicCellId", for: indexPath) as! PicCollectionCell
        cell.imageUrl = picUrls[indexPath.item]
        
        return cell
    }
}



class PicCollectionCell: UICollectionViewCell {
    
    var imageUrl:URL? {
        didSet{
            iconView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    
    @IBOutlet weak var iconView: UIImageView!
}


