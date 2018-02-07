//
//  PicPickerCollectionView.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/7.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit

private let picPickerCellId = "picPickerCellId"
private let edgeMargin : CGFloat = 15

class PicPickerCollectionView: UICollectionView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = (UIScreen.main.bounds.width - 4*edgeMargin) / 3
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumInteritemSpacing = edgeMargin
        layout.minimumLineSpacing = edgeMargin
        layout.sectionInset = UIEdgeInsets(top: edgeMargin, left: edgeMargin, bottom: 0, right: edgeMargin)
        
        dataSource = self
//        register(UICollectionViewCell.self, forCellWithReuseIdentifier: picPickerCellId)
        register(UINib(nibName: "PicPickerCell", bundle: nil), forCellWithReuseIdentifier: picPickerCellId)
    }
    
}

extension PicPickerCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picPickerCellId, for: indexPath)
        
        cell.backgroundColor = UIColor.red
        
        return cell
    }
}
