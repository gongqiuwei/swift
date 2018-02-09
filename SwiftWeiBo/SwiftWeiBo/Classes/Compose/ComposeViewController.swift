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
    fileprivate lazy var images: [UIImage] = [UIImage]()
    fileprivate lazy var emoticonVc : EmoticonViewController = EmoticonViewController { [weak self] (emoticon) in
        self?.insertEmoticonToTextView(emoticon: emoticon)
    }
    
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
    
    // 表情插入
    fileprivate func insertEmoticonToTextView(emoticon: Emoticon) {
        // 空白表情
        if emoticon.isEmpty {
            return
        }
        
        // 删除表情
        if emoticon.isRemove {
            textView.deleteBackward()
            return
        }
        
        // emoji表情
        if emoticon.emojiCode != nil {
            let textRange = textView.selectedTextRange!
            textView.replace(textRange, withText: emoticon.emojiCode!)
            
            return
        }
        
        // 处理普通表情的插入
        // 1.获取当前textView的attributedString
        let attrM = NSMutableAttributedString(attributedString: textView.attributedText)
        
        // 2.将表情转化为attributedString
        let attachment = EmoticonTextAttachment()
        // 2.1.绑定image
        attachment.image = UIImage(contentsOfFile: emoticon.pngPath!)
        // 2.2.设置尺寸
        let font = textView.font!
        // 2.3.绑定Attachment对应的chs文字
        attachment.chs = emoticon.chs
        attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        let imageAttr = NSAttributedString(attachment: attachment)
        
        // 3.在attrM的某个位置插入imageAttr
        let range = textView.selectedRange
        attrM.replaceCharacters(in: range, with: imageAttr)
        
        // 4.设置textView的attributedText
        textView.attributedText = attrM
        
        // 5.小bug修复
        // 5.1.输入表情后再输入其他会变小，也就是textView设置的font失效
        textView.font = font
        // 5.2.在中间插入表情，完成后光标会跳转到最后, 重新设置selectedRange
        textView.selectedRange = NSRange(location: range.location+1, length: 0)
    }
    
    fileprivate func getEmoticonTextForTextView() -> String{
        
        // 1.获取属性字符串
        let attrMStr = NSMutableAttributedString(attributedString: textView.attributedText)
        
        let range = NSRange(location: 0, length: attrMStr.length)
        attrMStr.enumerateAttributes(in: range, options: [], using: { (dict, range, _) in
            // 打印字典，查看普通文字和图片属性字符串的区别
            // 图片属性字符串有："NSAttachment": <NSTextAttachment: 0x6000002acd80>
            // range：当前字符串占据的位置
            // print(dict)
            
            if let attach = dict["NSAttachment"] as? EmoticonTextAttachment {
                // 需要将输入的NSTextAttachment换为对应 emoticon.chs
                // 系统的NSTextAttachment无法满足需求，因此在可以自定义类继承自NSTextAttachment
                // 在图文输入的时候，用自定义的Attachment替换系统的，并且绑定属性，在这里获取
                attrMStr.replaceCharacters(in: range, with: attach.chs!)
            }
        })
        
        return attrMStr.string
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
        print(getEmoticonTextForTextView())
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
    
    /// 表情点击
    @IBAction func emoticonClicked(){
        // 切换键盘
        textView.resignFirstResponder()
        textView.inputView = emoticonVc.view
        textView.becomeFirstResponder()
    }
    
    @IBAction private func defaultKeyboardClicked() {
        // 切换键盘
        textView.resignFirstResponder()
        textView.inputView = nil
        textView.becomeFirstResponder()
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
