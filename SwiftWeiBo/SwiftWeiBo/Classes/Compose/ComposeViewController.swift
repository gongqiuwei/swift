//
//  ComposeViewController.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/7.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    //MARK:- UI控件
    fileprivate lazy var titleView: ComposeTitleView = ComposeTitleView()
    @IBOutlet weak var textView: ComposeTextView!
    @IBOutlet weak var picPickerView: PicPickerCollectionView!

    // tool底部的约束
    @IBOutlet weak var toolBarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var picPickerViewHeightConstraint: NSLayoutConstraint!
    
    //MARK:- 存储属性
    lazy var images: [UIImage] = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavItem()
        
        // scrollview的属性，当没有内容的时候也可以滑动
        textView.alwaysBounceVertical = true
        
        // 添加通知
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.keyboardWillChangeFrame(note:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.addPhoto), name: Notification.Name(PicPickerViewAddPhotoNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.removePhoto(note:)), name: NSNotification.Name(PicPickerViewRemovePhotoNotification), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        textView.resignFirstResponder()
    }
    
    deinit {
        // 移除通知
        NotificationCenter.default.removeObserver(self)
    }
}

extension ComposeViewController {
    
    fileprivate func setupNavItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(ComposeViewController.closeItemClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(ComposeViewController.sendItemClicked))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        navigationItem.titleView = titleView
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
    }
    
    @objc private func closeItemClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func sendItemClicked() {
        print("sendItemClicked")
    }
    
    /// 监听键盘frame改变的通知
    @objc fileprivate func keyboardWillChangeFrame(note: Notification) {
        // 获取键盘动画时间
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        // 键盘的结束位置, 是NSRect类型， 不能直接强制转换成 CGRect， 会失败
        let endFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let endY = endFrame.origin.y
        
        // 动画
        toolBarBottomConstraint.constant = UIScreen.main.bounds.height - endY
        UIView.animate(withDuration: duration) { 
            self.view.layoutIfNeeded()
        }
    }
    
    /// 选择图片
    @IBAction func picPickerClicked() {
        // 退出键盘
        textView.resignFirstResponder()
        
        // 显示picPickerView
        picPickerViewHeightConstraint.constant = UIScreen.main.bounds.height * 0.65
        UIView.animate(withDuration: 0.5) { 
            self.view.layoutIfNeeded()
        }
    }
}

//MARK:- 照片处理
extension ComposeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 获取选择的照片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // 将照片展示到picPickerView中
        images.append(image)
        picPickerView.images = images
        
        // 推出picker
        picker.dismiss(animated: true, completion: nil)
    }
    
    /// 添加照片
    @objc fileprivate func addPhoto() {
        // 是否有权限
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return
        }
        
        // 创建选择照片
        let ipc = UIImagePickerController()
        ipc.sourceType = .photoLibrary
        ipc.delegate = self
        present(ipc, animated: true, completion: nil)
    }
    
    /// 删除照片
    @objc fileprivate func removePhoto(note: Notification) {
        // 要删除的照片
        guard let image = note.object as? UIImage else {
            return
        }
        
        // 查找在数组中的位置
        guard let index = images.index(of: image) else {
            return
        }
        
        // 删除
        images.remove(at: index)
        
        // 刷新
        picPickerView.images = images
    }
}



extension ComposeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.textView.placeHolderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}
