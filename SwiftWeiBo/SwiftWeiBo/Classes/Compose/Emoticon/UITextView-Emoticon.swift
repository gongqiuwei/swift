//
//  UITextView-Emoticon.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/9.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//  textView处理表情输入的扩展

import UIKit

extension UITextView {
    
    /// 向textView插入表情
    func insertEmoticon(emoticon: Emoticon) {
        // 空白表情
        if emoticon.isEmpty {
            return
        }
        
        // 删除表情
        if emoticon.isRemove {
            deleteBackward()
            return
        }
        
        // emoji表情
        if emoticon.emojiCode != nil {
            let textRange = selectedTextRange!
            replace(textRange, withText: emoticon.emojiCode!)
            
            return
        }
        
        // 处理普通表情的插入
        // 1.获取当前textView的attributedString
        let attrM = NSMutableAttributedString(attributedString: attributedText)
        
        // 2.将表情转化为attributedString
        let attachment = EmoticonTextAttachment()
        // 2.1.绑定image
        attachment.image = UIImage(contentsOfFile: emoticon.pngPath!)
        // 2.2.设置尺寸
        let font = self.font!
        // 2.3.绑定Attachment对应的chs文字
        attachment.chs = emoticon.chs
        attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        let imageAttr = NSAttributedString(attachment: attachment)
        
        // 3.在attrM的某个位置插入imageAttr
        let range = selectedRange
        attrM.replaceCharacters(in: range, with: imageAttr)
        
        // 4.设置textView的attributedText
        attributedText = attrM
        
        // 5.小bug修复
        // 5.1.输入表情后再输入其他会变小，也就是textView设置的font失效
        self.font = font
        // 5.2.在中间插入表情，完成后光标会跳转到最后, 重新设置selectedRange
        selectedRange = NSRange(location: range.location+1, length: 0)
    }
    
    /// 获取图文混排后的字符串
    func getEmoticonString() -> String {
        // 1.获取属性字符串
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        
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
