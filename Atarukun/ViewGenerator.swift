//
//  ViewGenerator.swift
//  Atarukun
//
//  Created by 大山 孝 on 2015/10/29.
//  Copyright © 2015年 oyama. All rights reserved.
//

import UIKit


//題名ラベル生成メソッド
func makeLabelTitle(title: String, frame: CGRect, fontSize: CGFloat, fontColor: UIColor, slope: Double) -> UILabel
{
    //文字装飾オブジェクト生成
    let attrStr = NSMutableAttributedString(string: title)
    
    //フォント設定　※うまく指定したフォントが取れてこなかったらクラッシュする(強制アンラップしてるしね！)
    attrStr.addAttribute(NSFontAttributeName, value: UIFont(name: "HiraKakuProN-W6", size: fontSize)! , range: NSMakeRange(0, attrStr.length))
    
    //背景色設定
    attrStr.addAttribute(NSBackgroundColorAttributeName, value: UIColor.clearColor(), range: NSMakeRange(0, attrStr.length))
    
    //影設定
    let shadow = NSShadow()
    shadow.shadowColor = UIColor.whiteColor() //白
    shadow.shadowBlurRadius = 0.1             //拡散具合
    shadow.shadowOffset = CGSizeMake(4, 4)    //x方向とy方向のずれ具合
    attrStr.addAttribute(NSShadowAttributeName, value: shadow, range: NSMakeRange(0, attrStr.length))
    
    //文字色
    attrStr.addAttribute(NSForegroundColorAttributeName, value: fontColor, range: NSMakeRange(0, attrStr.length))
    
    //ラベル生成
    let label = UILabel()
    label.frame = frame
    label.attributedText = attrStr
    label.sizeToFit()
    
    //回転具合
    label.transform = CGAffineTransformRotate(label.transform, CGFloat(slope * M_1_PI))
    
    //viewに配置
    return label
}

//結果表示ラベル生成メソッド
func makeLabel(shitenX: CGFloat, shitenY: CGFloat) -> UILabel
{
    let label = UILabel(frame: CGRectMake(shitenX, shitenY, 45, 39))
    label.font = UIFont(name: "7barSPBd", size: 34.0)
    label.backgroundColor = UIColor.clearColor()
    return label
}

//ボタン生成メソッド(５個)
func makeButton(tag: Int, shiten: CGFloat, originHeight: CGFloat, image: String) -> (UIButton, UILabel)
{
    let button = UIButton()
    
    //ロト７ボタンのイメージ画像だけ高さ＋２０ポイント(上下それぞれ＋１０ポイント)
    if tag == LOTOPART.LOTO7.rawValue {
        button.frame = CGRectMake(shiten, originHeight - 95, 70, 50)
    } else {
        button.frame = CGRectMake(shiten, originHeight - 85, 70, 30)
    }
    
    button.setBackgroundImage(UIImage(named: image), forState: .Normal)
    button.tag = tag
    
    //ついでに黒丸も配置
    let blackCircle = UILabel(frame: CGRectMake(shiten + 20, originHeight - 120, 25, 25))
    blackCircle.text = "・"
    blackCircle.font = UIFont.systemFontOfSize(35)
    blackCircle.textColor = UIColor.blackColor()
    
    return (button,blackCircle)
}

//SNSボタン生成
func makeButtonSNS(tag: Int, frame: CGRect, image: String) -> UIButton
{
    let button = UIButton()
    
    button.frame = frame
    button.setBackgroundImage(UIImage(named: image), forState: .Normal)
    button.tag = tag
    button.enabled = false
    
    return button
}