//
//  EmoticonCell.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/8.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit

class EmoticonCell: UICollectionViewCell {
    
    private lazy var emoticonBtn: UIButton = UIButton()
    var emoticon: Emoticon? {
        didSet{
            guard let emoticon = emoticon else {
                return
            }
            
            emoticonBtn.setImage(UIImage(named: emoticon.pngPath ?? ""), for: .normal)
            emoticonBtn.setTitle(emoticon.emojiCode, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- 私有方法
    private func setupUI() {
        contentView.addSubview(emoticonBtn)
        
        emoticonBtn.frame = contentView.bounds
        emoticonBtn.isUserInteractionEnabled = false
        emoticonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
    }
}
