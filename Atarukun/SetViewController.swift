//
//  SetViewController.swift
//  Atarukun
//
//  Created by 大山 孝 on 2015/10/24.
//  Copyright © 2015年 oyama. All rights reserved.
//

import UIKit

//main画面に戻った時に設定した配列を渡せる用プロトコル
protocol SetViewDelegate {
    func finishSetting(returnValue: [[Int]])
}

class SetViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //ピッカー
    var pickerView = UIPickerView()
    
    //くじ別数字配列を用意
    var itemNumbers: [String] = []
    var itemMini: [String] = []
    var itemLoto6: [String] = []
    var itemLoto7: [String] = []
    
    //main画面に返す配列
    let num3Array = [0, 0, 0]
    let num4Array = [0, 0, 0, 0]
    let miniArray = [0, 0, 0, 0, 0]
    let loto6Array = [0, 0, 0, 0, 0, 0]
    let loto7Array = [0, 0, 0, 0, 0, 0, 0]
    
    //ArrayをまとめるArray
    var kujiKindArray: [[Int]] = []
    
    //選択されたボタン判定用(ナンバーズ３で初期化)
    var choiceSeg = LOTOPART.NUM3.rawValue
    
    //戻る時のドラム数
    var returnDrums = 0
    
    //戻るボタン
    var backButton = UIButton()
    
    //全部初期値に戻すボタン
    var resetButton = UIButton()
    
    //メイン画面に値を戻す用のデリゲート変数
    var delegate: SetViewDelegate?
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //背景は白
        self.view.backgroundColor = UIColor.whiteColor()
        
        //メイン画面遷移用ボタン（戻る）
        backButton.frame = CGRectMake(self.view.bounds.size.width - 55, 40, 40, 30)
        backButton.setTitle("戻る", forState: .Normal)
        backButton.setTitleColor(UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0), forState: .Normal)
        backButton.addTarget(self, action: "back:", forControlEvents: .TouchUpInside)
        self.view.addSubview(backButton)
        
        //全部初期値に戻すボタン（Reset）
        resetButton.frame = CGRectMake(15, 40, 60, 30)
        resetButton.setTitle("Reset", forState: .Normal)
        resetButton.setTitleColor(UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0), forState: .Normal)
        resetButton.addTarget(self, action: "resetDrum:", forControlEvents: .TouchUpInside)
        self.view.addSubview(resetButton)
        
        //各ドラムに表示するセル数用配列の値をセット
        itemNumbers = itemSet(0, max: 9)
        itemMini = itemSet(1, max: 31)
        itemLoto6 = itemSet(1, max: 43)
        itemLoto7 = itemSet(1, max: 37)
        
        //ピッカービューの配置
        pickerView.frame = CGRectMake(self.view.bounds.size.width / 2 - 160, 40, 320, 216)
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        pickerView.layer.borderColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 0.1).CGColor
        pickerView.layer.borderWidth = 1.0
        self.view.addSubview(pickerView)
        
        //セグメントコントロールの生成と配置
        let segArray = ["ナン３", "ナン４", "ミニロト", "ロト６", "ロト７"]
        let seg = UISegmentedControl(items: segArray)
        seg.frame = CGRectMake(self.view.bounds.size.width / 2 - 190, 280, 380, 30)
        seg.selectedSegmentIndex = 0
        seg.addTarget(self, action: "swithPickKind:", forControlEvents: .ValueChanged)
        self.view.addSubview(seg)
        
        //メイン画面に返すArrayをまとめとく
        kujiKindArray = [num3Array, num4Array, miniArray, loto6Array, loto7Array]
    }
    
    
    //最終値、およびラベル表示文字列の配列セットメソッド
    func itemSet(min: Int, max: Int) -> [String]
    {
        var returnArray: [String] = []
        
        //先頭にANYを追加
        returnArray.append("ANY")
        
        for var i = min; i <= max; i++ {
            if max == 9 {
                returnArray.append(String(i))
            } else {
                returnArray.append(String(format:"%02d", i))
            }
        }
        return returnArray
    }
    
//MARK: - UIPickerViewのデリゲートセクション
    
    //UIPickerViewのデリゲートメソッド(各行のセル生成)
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let cell = UIView(frame: CGRectMake(0, 0, 40, 30))
        
        let label = UILabel(frame: CGRectMake(0, 0, 40, 30))
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        
        switch choiceSeg {
            case LOTOPART.MINI.rawValue:
                label.text = itemMini[row]
            
            case LOTOPART.LOTO6.rawValue:
                label.text = itemLoto6[row]
            
            case LOTOPART.LOTO7.rawValue:
                label.text = itemLoto7[row]
            
            default:
                label.text = itemNumbers[row]
        }
        
        cell.addSubview(label)
        
        return cell
    }
    
    //UIPickerViewのデリゲートメソッド(行数取得)
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var returnRows = 0
        
        switch choiceSeg {
            case LOTOPART.NUM3.rawValue:
                fallthrough
            case LOTOPART.NUM4.rawValue:
                returnRows = itemNumbers.count
            
            case LOTOPART.MINI.rawValue:
                returnRows = itemMini.count
            
            case LOTOPART.LOTO6.rawValue:
                returnRows = itemLoto6.count
                
            case LOTOPART.LOTO7.rawValue:
                returnRows = itemLoto7.count
                
            default: break
        }
        
        return returnRows
    }
    
    //UIPickerViewのデリゲートメソッド(ドラム数取得)
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        switch choiceSeg {
        case LOTOPART.NUM3.rawValue:
            returnDrums = 3
            
        case LOTOPART.NUM4.rawValue:
            returnDrums = 4
            
        case LOTOPART.MINI.rawValue:
            returnDrums = 5
            
        case LOTOPART.LOTO6.rawValue:
            returnDrums = 6
            
        case LOTOPART.LOTO7.rawValue:
            returnDrums = 7
            
        default: break
        }
        
        return returnDrums
    }
    
    //UIPickerViewのデリゲートメソッド(行の高さ取得)
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
//MARK: - 細々ロジックセクション
    
    //pickerviewの選択値を格納
    func savePickValue() -> Bool
    {
        kujiKindArray[choiceSeg - 101].removeAll()
        
        var alertCount = 0
        for var i = 0; i < returnDrums; i++ {
            kujiKindArray[choiceSeg - 101].append(pickerView.selectedRowInComponent(i))
            if kujiKindArray[choiceSeg - 101][i] != 0 {
                alertCount++
            }
        }
        
        //全部がANY(0)以外だったらYESを返してshowAleartしてスキップ
        return alertCount == kujiKindArray[choiceSeg - 101].count ? true : false
    }
    
    //pickerViewに記憶されていた値をロード
    func loadPickValue() {
        //直前のピッカービューがどのくじ種類を表示してたかを判定
        var targetArray = kujiKindArray[choiceSeg - 101]
        
        //記憶されている選択値をロード
        for var i = 0; i < returnDrums; i++ {
            pickerView.selectRow(targetArray[i], inComponent: i, animated: false)
        }
    }
    
//MARK: - アクションセクション
    
    //セグメントコントロールの値が変わったら呼ばれる
    func swithPickKind(seg: UISegmentedControl)
    {
        //全選択なら舐めた口調で返そう
        if savePickValue() {
            displayAlertMessage("数字全部決まってるのならその数字そのまま買えば？")
            //セグメントを元に戻して以降スキップ
            seg.selectedSegmentIndex = choiceSeg - 101
            return
        }
        
        //直前のPickerViewの値をArrayに格納
        choiceSeg = seg.selectedSegmentIndex + 101
        pickerView.reloadAllComponents()
        loadPickValue()
    }
    
    //Resetボタンクリック時コール
    func resetDrum(button: UIButton)
    {
        let drumCount = numberOfComponentsInPickerView(pickerView)
        
        for var i = 0; i < drumCount; i++ {
            pickerView.selectRow(0, inComponent: i, animated: true)
        }
    }
    
    //戻るボタンクリック時コール
    func back(button: UIButton)
    {
        //最終的に表示されてるpickerViewの値を配列に格納するけどオールANY以外ならアラート表示してスキップ
        if savePickValue() {
            displayAlertMessage("数字全部決まってるのならその数字そのまま買えば？")
            return
        }
        
        //メイン画面に返す
        delegate?.finishSetting(kujiKindArray)
        
        //設定画面を閉じる
        self.dismissViewControllerAnimated(true, completion: nil)
    }

//MARK: - その他もろもろセクション
    
    //アラートメッセージ共通メソッド
    func displayAlertMessage(message: String)
    {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action) -> Void in}
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    //メモリワーニング
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
}
