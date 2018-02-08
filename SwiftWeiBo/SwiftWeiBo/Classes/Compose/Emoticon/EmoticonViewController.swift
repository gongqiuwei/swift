//
//  EmoticonViewController.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/8.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit

private let EmoticonCellId = "EmoticonCellId"

class EmoticonViewController: UIViewController {

    //MARK:- 懒加载属性
    fileprivate lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmoticonCollectionLayout())
    fileprivate lazy var toolBar: UIToolbar = UIToolbar()
    fileprivate lazy var emoticonManager: EmoticonManager = EmoticonManager()
    
    //MARK:- 系统函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
//        testPrintAllEmoticons()
    }
    
    /// 测试打印所有的表情模型
    private func testPrintAllEmoticons() {
        let manager = EmoticonManager()
        for package in manager.packages {
            for emoticon in package.emoticons {
                print(String(reflecting: emoticon))
            }
        }
    }
}

//MARK:- UI布局
extension EmoticonViewController {
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.lightGray
        
        addSubViews()
        prepareForCollectionView()
        prepareForToolBar()
    }
    
    /// 添加子控件并布局
    private func addSubViews() {
        // 添加子控件
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        collectionView.backgroundColor = UIColor.purple
        toolBar.backgroundColor = UIColor.darkGray
        
        // 布局(使用VFL布局)
        // 使用代码的autolayout必须设置控件的下面属性，不然无法生效
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        // 水平方向的约束
        let views = ["tBar": toolBar, "cView": collectionView] as [String : Any]
        let hStr = "H:|-0-[tBar]-0-|"
        var cons = NSLayoutConstraint.constraints(withVisualFormat: hStr, options: [], metrics: nil, views: views)
        
        // 垂直方向的约束
        let vStr = "V:|-0-[cView]-0-[tBar]-0-|"
        // 垂直方向上，2个控件左右对齐
        cons += NSLayoutConstraint.constraints(withVisualFormat: vStr, options: [.alignAllLeading, .alignAllTrailing], metrics: nil, views: views)
        // 添加约束
        view.addConstraints(cons)
    }
    
    /// 设置collectionview
    private func prepareForCollectionView() {
        // 设置collectionview的属性
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.dataSource = self
        collectionView.register(EmoticonCell.self, forCellWithReuseIdentifier: EmoticonCellId)
    }
    
    /// 设置底部的toolBar
    private func prepareForToolBar() {
        let titles = ["最近", "默认", "emoji", "浪小花"]
        
        var tempItems = [UIBarButtonItem]()
        for (index, title) in titles.enumerated() {
            // 创建item
            let item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(EmoticonViewController.toolBarItemClicked(item:)))
            item.tag = index
            tempItems.append(item)
            
            // 添加弹簧item
            tempItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        tempItems.removeLast()
        
        // 给toolBar设置items
        toolBar.items = tempItems
        toolBar.tintColor = UIColor.orange
    }
    
    @objc private func toolBarItemClicked(item: UIBarButtonItem) {
        let indexPath = IndexPath(item: 0, section: item.tag)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
}


extension EmoticonViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return emoticonManager.packages.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let package = emoticonManager.packages[section]
        return package.emoticons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmoticonCellId, for: indexPath) as! EmoticonCell
        
        cell.backgroundColor = indexPath.item%2==0 ? UIColor.red : UIColor.blue
        let package = emoticonManager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        cell.emoticon = emoticon
        
        return cell
    }
}


class EmoticonCollectionLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        // 设置布局
        let itemWH = UIScreen.main.bounds.width / 7
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        // 3行表情，每行7列
        guard let collectionView = collectionView else {
            return
        }
        
        // insetMargin计算
        let insetMargin = (collectionView.bounds.height - 3 * itemWH) / 2
        sectionInset = UIEdgeInsets(top: insetMargin, left: 0, bottom: insetMargin, right: 0)
    }
}
