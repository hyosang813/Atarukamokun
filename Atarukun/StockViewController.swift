//
//  StockViewController.swift
//  Atarukun
//
//  Created by 大山 孝 on 2015/10/29.
//  Copyright © 2015年 oyama. All rights reserved.
//

import UIKit

class StockViewController: UIViewController {
    
    //結果表示のテキストビュー
    var resultVeiw = UITextView()
    
    //戻るボタン
    var backButton = UIButton()
    
    //セグメントコントロール
    let seg = UISegmentedControl(items: ["ナン３", "ナン４", "ミニロト", "ロト６", "ロト７"])
    
    //最新抽出クジ種類
    var kujiKind: Int?
    
    //各文字列を格納するArray
    var stringArray: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //背景は薄い水色
        self.view.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        //セグメントコントロールの配置
        seg.frame = CGRectMake(self.view.bounds.size.width / 2 - 190, 280, 380, 30)
        if kujiKind >= 0 {
            seg.selectedSegmentIndex = kujiKind!
        } else {
            seg.selectedSegmentIndex = 0
        }
        seg.addTarget(self, action: "swithPickKind:", forControlEvents: .ValueChanged)
        self.view.addSubview(seg)
        
        //メイン画面遷移用ボタン（戻る）
        backButton.frame = CGRectMake(self.view.bounds.size.width - 55, 40, 40, 30)
        backButton.setTitle("戻る", forState: .Normal)
        backButton.setTitleColor(UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0), forState: .Normal)
        backButton.addTarget(self, action: "back:", forControlEvents: .TouchUpInside)
        self.view.addSubview(backButton)
        
        //テキストビューを配置
        resultVeiw.frame = CGRectMake(self.view.bounds.size.width / 2 - 140, 30, 280, 200)
        resultVeiw.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        resultVeiw.editable = false
        resultVeiw.font = UIFont(name: "Courier", size: 16.0)
        resultVeiw.layer.borderWidth = 2
        resultVeiw.layer.borderColor = UIColor.blackColor().CGColor
        self.view.addSubview(resultVeiw)
        
        //各String変数の値を更新
        setString()
    }
    
    //各String変数を最新状態にする
    func setString()
    {
        let array = stringArray[seg.selectedSegmentIndex]
        if array.count == 0 {
            resultVeiw.text = "なし"
        } else {
            resultVeiw.text = ""
            for str in array {
                resultVeiw.text = resultVeiw.text + str + " ATKK\n"
            }
        }
    }
    
    //セグメントコントロールの値が変わったら呼ばれる
    func swithPickKind(seg: UISegmentedControl)
    {
        //各String変数の値を更新
        setString()
    }
    
    //戻るボタンクリック時コール
    func back(button: UIButton)
    {
        //保存画面を閉じる
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //メモリワーニング
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
}
