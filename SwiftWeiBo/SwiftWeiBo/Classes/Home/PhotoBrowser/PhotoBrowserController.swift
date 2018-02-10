//
//  PhotoBrowserController.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/10.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit
import SnapKit

private let PhotoBrowserCellId = "PhotoBrowserCellId"

class PhotoBrowserController: UIViewController {
    
    //MARK:- 属性
    var picUrls: [URL]
    var indexPath: IndexPath
    
    //MARK:- lazy属性
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = UIScreen.main.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.register(PhotoBrowserCell.self, forCellWithReuseIdentifier: PhotoBrowserCellId)
        
        return collectionView
    }()
    fileprivate lazy var closeBtn: UIButton = {
        let btn = UIButton(title: "关 闭", bgColor: UIColor.darkGray, fontSize: 14)
        btn.addTarget(self, action: #selector(PhotoBrowserController.closeBtnClicked), for: .touchUpInside)
        return btn
    }()
    fileprivate lazy var saveBtn: UIButton = {
        let btn = UIButton(title: "保 存", bgColor: UIColor.darkGray, fontSize: 14)
        btn.addTarget(self, action: #selector(PhotoBrowserController.saveBtnClicked), for: .touchUpInside)
        return btn
    }()
    
    //MARK:- 构造函数
    init(picUrls: [URL], indexPath: IndexPath) {
        
        self.picUrls = picUrls
        self.indexPath = indexPath
        
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK:- UI布局
extension PhotoBrowserController {
    fileprivate func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        collectionView.frame = view.bounds
        closeBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        saveBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-20)
            make.size.bottom.equalTo(closeBtn)
        }
    }
}


//MARK:- 事件处理
extension PhotoBrowserController {
    @objc fileprivate func closeBtnClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func saveBtnClicked() {
        print("saveBtnClicked")
    }
}


//MARK:- collectionView代理
extension PhotoBrowserController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserCellId, for: indexPath) as! PhotoBrowserCell
        
        cell.picUrl = picUrls[indexPath.item]
        
        return cell
    }
}

