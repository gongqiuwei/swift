//
//  PhotoBrowserController.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/10.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

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
        
        // collectionview滚动的相应位置
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
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
        
        // 为了cell之间有分割效果，重新设置
        // 原理，page效果是根据collectionview的width来的，让collectionview的width增加，cell的宽度增加，然后cell的内容宽度减少，这样就由间隔了
        collectionView.frame.size.width += 20
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize.width = collectionView.frame.size.width
    }
}


//MARK:- 事件处理
extension PhotoBrowserController {
    @objc fileprivate func closeBtnClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func saveBtnClicked() {
        let cell = collectionView.visibleCells.first as! PhotoBrowserCell
        guard let image = cell.imageView.image else {
            return
        }
        
        //  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(PhotoBrowserController.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc fileprivate func image(_ image:UIImage, didFinishSavingWithError error:Error?, contextInfo: AnyObject) {
        if error != nil {
            SVProgressHUD.showInfo(withStatus: "保存失败")
        } else {
            SVProgressHUD.showInfo(withStatus: "保存成功")
        }
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

