//
//  MainViewController.swift
//  Atarukun
//
//  Created by 大山 孝 on 2015/10/22.
//  Copyright © 2015年 oyama. All rights reserved.
//

import UIKit
import Social

//くじ種類のenum
enum LOTOPART: Int {
    case NUM3 = 101
    case NUM4
    case MINI
    case LOTO6
    case LOTO7
    case SETING
}

//SNS種類のenum
enum SNSPART: Int {
    case TWITTER
    case FACEBOOK
    case LINE
}


class MainViewController: UIViewController, SetViewDelegate {
    //MARK: - インスタンス変数宣言セクション
    
    //結果表示ラベルの土台
    var resultView =  UIView()

    //結果表示ラベルの枠（本来こんなくだらない解決策以外を考えるはず・・・）
    //このフォント使うとラベルの上下と左右に若干ズレるので枠線書くとめっちゃ汚いから枠線用のラベルと値表示用のラベルを若干ずらして設定
    var labelFirstWaku =  UILabel()
    var labelSecondWaku =  UILabel()
    var labelThirdWaku =  UILabel()
    var labelFourthWaku =  UILabel()
    var labelFifthWaku =  UILabel()
    var labelSixethWaku =  UILabel()
    var labelSeventhWaku =  UILabel()
    
    //結果表示ラベル
    var labelFirst =  UILabel()
    var labelSecond =  UILabel()
    var labelThird =  UILabel()
    var labelFourth =  UILabel()
    var labelFifth =  UILabel()
    var labelSixeth =  UILabel()
    var labelSeventh =  UILabel()
    
    //各５つのボタン
    var num3Button = UIButton()
    var num4Button = UIButton()
    var miniButton = UIButton()
    var loto6Button = UIButton()
    var loto7Button = UIButton()
    
    //SNSクライアント表示ボタン
    var twitterButton = UIButton()
    var facebookButton = UIButton()
    var lineButton = UIButton() //定義だけでボタン生成はしてないです？？？？？
    
    //設定画面遷移用ボタン
    var setButton = UIButton()
    
    //設定情報格納Array
    var setArray: [Int] = []
    
    //設定情報格納Arrayの親Array
    var setArrayParent: [[Int]] = []
    
    //起動時アニメーション乱数保配列
    var startArray: [String] = []
    
    //ロト系最終表示用配列
    var endArray: [String] = []
    
    //左右アニメーション用タイマー
    var tm: NSTimer?
    
    //高速回転用タイマー
    var highTm: NSTimer?
    
    //点滅表示用タイマー
    var blinkTm: NSTimer?
    
    //アニメーション中か否かの判定
    var animeSwitch = false
    
    //設定情報くじ種類（こっちのenumとリンク）
    var choiceSeg: Int?
    
    //左右アニメーションカウンター
    var animationCount = 0
    
    //押されたボタンのタグ情報格納
    var buttonKind = 0
    
    //ボタンが押されて何回目か？
    var buttonCount = 0
    
    //ios7とios8で画面の向きによるwidthとheightの取得方法が異なるので、切り分け用インスタンス変数
    var myWidth: Float?
    var myHeight: Float?
    
    //左右アニメーションを滑らかにするための別Array ※2015/03/16追加
    var tempStartArray: [String] = []
    
    //結果表示ラベルをまとめたArray
    var labelArray: [UILabel] = []
    
    //ロト系の順次表示用タイマーとカウンタ
    var orderTim: NSTimer?
    var orderCount = 0
    
    //設定画面インスタンス
    var svc: SetViewController?
    
    
    //MARK: - viewDidLoadセクション
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //画面背景色は黄色
        self.view.backgroundColor = UIColor.yellowColor()
        
        //iosVerによる切り分け処理
        myWidth = Float(self.view.bounds.size.width)
        myHeight = Float(self.view.bounds.size.height)
        
        //ios7以下だったら縦横入れ替え CGFloatをFloatにキャストしてるけど本当にこんなんでself.viewのプロパティ値がかわんのか？？？？？
        //てかios7はもう動作対象から外すか？？？？？
        if Float(UIDevice.currentDevice().systemVersion) < 8.0 {
            let tmpWidth = myWidth
            myWidth = myHeight
            myHeight = tmpWidth
            self.view.bounds.size.width = CGFloat(myWidth!)
            self.view.bounds.size.height = CGFloat(myHeight!)
        }
        
        //題名ラベルの生成「あたるクン」 ※ちっちゃーく「かも」を入れる
        makeLabelTitle("あ", rect: CGRectMake(self.view.bounds.size.width / 2 - 135, self.view.bounds.size.height / 2 - 100, 220, 50), fontSize: 60.0, fontColor: UIColor.redColor(), slope: -0.5)
        makeLabelTitle("た", rect: CGRectMake(self.view.bounds.size.width / 2 - 65, self.view.bounds.size.height / 2 - 100, 220, 50), fontSize: 60.0, fontColor: UIColor(red: 1.0, green: 0.747, blue: 0, alpha: 1), slope: 0.5)
        makeLabelTitle("る", rect: CGRectMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2 - 100, 220, 50), fontSize: 60.0, fontColor: UIColor(red: 1.0, green: 0.412, blue: 0.706, alpha: 1), slope: -0.5)
        makeLabelTitle("ク", rect: CGRectMake(self.view.bounds.size.width / 2 + 75, self.view.bounds.size.height / 2 - 100, 30, 30), fontSize: 36.0, fontColor: UIColor.greenColor(), slope: 0.2)
        makeLabelTitle("ン", rect: CGRectMake(self.view.bounds.size.width / 2 + 100, self.view.bounds.size.height / 2 - 75, 30, 30), fontSize: 36.0, fontColor: UIColor.purpleColor(), slope: 0.2)
        makeLabelTitle("かも", rect: CGRectMake(self.view.bounds.size.width / 2 + 65, self.view.bounds.size.height / 2 - 50, 20, 10), fontSize: 8.0, fontColor: UIColor.redColor(), slope: 0)
        
        //結果表示用のラベル土台VIEW配置
        resultView.frame = CGRectMake(self.view.bounds.size.width / 2 - 160, self.view.bounds.size.height / 2 - 20, 323, 48)
        resultView.layer.cornerRadius = 10.0
        resultView.layer.borderColor = UIColor.lightGrayColor().CGColor
        resultView.layer.borderWidth = 1.0
        resultView.clipsToBounds = true
        resultView.backgroundColor = UIColor(red: 0.40, green: 0.80, blue: 0.67, alpha: 1)
        self.view.addSubview(resultView)
        
        //結果表示用のラベル配置（枠）
        labelFirstWaku = makeLabel(resultView.bounds.origin.x + 2.5, shitenY:resultView.bounds.origin.y + 5)
        labelSecondWaku = makeLabel(resultView.bounds.origin.x + 47.5, shitenY:resultView.bounds.origin.y + 5)
        labelThirdWaku = makeLabel(resultView.bounds.origin.x + 92.5, shitenY:resultView.bounds.origin.y + 5)
        labelFourthWaku = makeLabel(resultView.bounds.origin.x + 137.5, shitenY:resultView.bounds.origin.y + 5)
        labelFifthWaku = makeLabel(resultView.bounds.origin.x + 182.5, shitenY:resultView.bounds.origin.y + 5)
        labelSixethWaku = makeLabel(resultView.bounds.origin.x + 227.5, shitenY:resultView.bounds.origin.y + 5)
        labelSeventhWaku = makeLabel(resultView.bounds.origin.x + 272.5, shitenY:resultView.bounds.origin.y + 5)
        
        
        //結果表示用のラベル配置（そのもの）
        labelFirst = makeLabel(resultView.bounds.origin.x + 3.5, shitenY:resultView.bounds.origin.y + 7)
        labelSecond = makeLabel(resultView.bounds.origin.x + 48.5, shitenY:resultView.bounds.origin.y + 7)
        labelThird = makeLabel(resultView.bounds.origin.x + 93.5, shitenY:resultView.bounds.origin.y + 7)
        labelFourth = makeLabel(resultView.bounds.origin.x + 138.5, shitenY:resultView.bounds.origin.y + 7)
        labelFifth = makeLabel(resultView.bounds.origin.x + 183.5, shitenY:resultView.bounds.origin.y + 7)
        labelSixeth = makeLabel(resultView.bounds.origin.x + 228.5, shitenY:resultView.bounds.origin.y + 7)
        labelSeventh = makeLabel(resultView.bounds.origin.x + 273.5, shitenY:resultView.bounds.origin.y + 7)
        
        //結果表示ラベルをArrayにまとめとく
        labelArray = [labelFirst, labelSecond, labelThird, labelFourth, labelFifth, labelSixeth, labelSeventh]
        
        //設定画面遷移用ボタン配置
        setButton = UIButton(frame: CGRectMake(self.view.bounds.size.width - 65, 30, 50, 50))
        setButton.setBackgroundImage(UIImage(named: "haguruma.png"), forState: .Normal)
        setButton.addTarget(self, action: "transSetMode", forControlEvents: .TouchUpInside)
        setButton.enabled = true
        self.view.addSubview(setButton)
        
        //twitter連携ボタン配置
        twitterButton = UIButton(frame: CGRectMake(self.view.bounds.size.width - 50, 100, 30, 30))
        twitterButton.setBackgroundImage(UIImage(named: "twitter.png"), forState: .Normal)
        twitterButton.addTarget(self, action: "socialButton:", forControlEvents: .TouchUpInside)
        twitterButton.tag = SNSPART.TWITTER.rawValue
        twitterButton.enabled = false
        self.view.addSubview(twitterButton)
        
        //facebook連携ボタン配置
        facebookButton = UIButton(frame: CGRectMake(self.view.bounds.size.width - 50, 150, 30, 30))
        facebookButton.setBackgroundImage(UIImage(named: "facebook.png"), forState: .Normal)
        facebookButton.addTarget(self, action: "socialButton:", forControlEvents: .TouchUpInside)
        facebookButton.tag = SNSPART.FACEBOOK.rawValue
        facebookButton.enabled = false
        self.view.addSubview(facebookButton)
        
        //ランダム数値生成ボタン配置(５個）
        num3Button = makeButton(LOTOPART.NUM3.rawValue, shiten:self.view.bounds.size.width / 2 - 200, image: "numbers3.jpg")
        num4Button = makeButton(LOTOPART.NUM4.rawValue, shiten:self.view.bounds.size.width / 2 - 117.5, image: "numbers4.jpg")
        miniButton = makeButton(LOTOPART.MINI.rawValue, shiten:self.view.bounds.size.width / 2 - 35, image: "miniloto.jpg")
        loto6Button = makeButton(LOTOPART.LOTO6.rawValue, shiten:self.view.bounds.size.width / 2 + 47.5, image: "loto6.jpg")
        loto7Button = makeButton(LOTOPART.LOTO7.rawValue, shiten:self.view.bounds.size.width / 2 + 130, image: "loto7.jpg")
    }
    
    //MARK: - 他メソッドセクション
    
    //題名ラベル生成メソッド
    func makeLabelTitle(title: String, rect: CGRect, fontSize: CGFloat, fontColor: UIColor, slope: Double)
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
        label.attributedText = attrStr
        label.sizeToFit()
        
        //回転具合
        label.transform = CGAffineTransformRotate(label.transform, CGFloat(slope * M_1_PI))
        
        //viewに配置
        self.view.addSubview(label)
    }
    
    //結果表示ラベル生成メソッド
    func makeLabel(shitenX: CGFloat, shitenY: CGFloat) -> UILabel
    {
        let label = UILabel(frame: CGRectMake(shitenX, shitenY, 45, 39))
        label.font = UIFont(name: "7barSPBd", size: 34.0)
        label.backgroundColor = UIColor.clearColor()
        resultView.addSubview(label)
        return label
    }
    
    //ボタン生成メソッド(５個)
    func makeButton(tag: Int, shiten: CGFloat, image: String) -> UIButton
    {
        let button = UIButton()
        
        //ロト７ボタンのイメージ画像だけ高さ＋２０ポイント(上下それぞれ＋１０ポイント)
        if tag == LOTOPART.LOTO7.rawValue {
            button.frame = CGRectMake(shiten, self.view.bounds.size.height - 95, 70, 50)
        } else {
            button.frame = CGRectMake(shiten, self.view.bounds.size.height - 85, 70, 30)
        }
        
        button.setBackgroundImage(UIImage(named: image), forState: .Normal)
        button.addTarget(self, action: "push:", forControlEvents: .TouchUpInside)
        button.tag = tag
        self.view.addSubview(button)
        
        //ついでに黒丸も配置
        let blackCircle = UILabel(frame: CGRectMake(shiten + 20, self.view.bounds.size.height - 120, 25, 25))
        blackCircle.text = "・"
        blackCircle.font = UIFont.systemFontOfSize(35)
        blackCircle.textColor = UIColor.blackColor()
        self.view.addSubview(blackCircle)
        
        return button
    }
    
    //初回ボタン押下直後に枠線を描画
    func drawLabelFrame()
    {
        let tempArray = [labelFirstWaku, labelSecondWaku, labelThirdWaku, labelFourthWaku, labelFifthWaku, labelSixethWaku, labelSeventhWaku]
        for label in tempArray {
            //枠
            label.layer.borderWidth = 1.0
            
            //下部中央をあける
            let iv = UIImageView(image: UIImage(named: "kabuana.png"))
            iv.frame = CGRectMake(label.frame.origin.x + label.bounds.size.width / 2 - 2.5 , label.frame.origin.y + label.bounds.size.height - 2.5, 5, 5)
            resultView.addSubview(iv)
        }
    }
    
    //くじボタン押下時の挙動
    func push(button: UIButton)
    {
        //animeSwitchがtrue(アニメーション中)は以降の処理を全スキップ
        if animeSwitch {
            return
        }
        
        switch buttonCount {
            case 0: //ボタンカウント0の時は表示窓枠を描画し左右&高速アニメーション　※設定ボタンは選択不可能状態に非活性化
                animeSwitch = true
                setButton.enabled = false
                twitterButton.enabled = false
                facebookButton.enabled = false
                drawLabelFrame()
                firstPress(button.tag)
            
            case 1: //ボタンカウント1の時はラベルを点滅表示
                blinkAnime()
            
            case 2: //ボタンカウント2の時はラベルの点滅終了　※選択不可状態の設定ボタンを活性化
                setButton.enabled = true;
                twitterButton.enabled = true;
                facebookButton.enabled = true;
                blinkStop()
            
            default: break
        }
    }
    
    //初回ボタン操作時は左右アニメーションからの高速回転まで
    func firstPress(tag: Int)
    {
        //押されたボタンのタグ情報を判定用変数に格納
        buttonKind = tag
        
        if let tempTm = tm {
            //tmタイマー動作中であれば一旦止める
            if tempTm.valid {
                animationCount = 0 //まずはカウンターを初期化
            
                tempTm.invalidate() //タイマー停止
                tm = nil
            }
        }
        
        //右にずれて数字が消えて、さらに出現するまでのタイマースタート
        tm = NSTimer.scheduledTimerWithTimeInterval(0.13, target: self, selector: "labelTextClear", userInfo: nil, repeats: true)
    }
    
    //2回目にボタンを押されたら点滅表示
    func blinkAnime()
    {
        //高速回転highTmタイマーストップ
        if let tempTm = highTm {
            tempTm.invalidate() //タイマー停止
            highTm = nil
        }
        
        //ナンバーズ系共通処理 ナンバーズは高速回転の最後の値を使用
        if buttonKind == LOTOPART.NUM3.rawValue || buttonKind == LOTOPART.NUM4.rawValue {
        
            //serArrayParent情報なし(設定画面開いてない)だったらsetArray系処理はスキップ
            if setArrayParent.count != 0 {
                setArray = setArrayParent[buttonKind - 101]
            }
            
            //設定画面で指定された数字があれば(99じゃなかったら)置き換える
            let labelArray = [labelFirst, labelSecond, labelThird, labelFourth]
            for var i = 0; i < setArray.count; i++ {
                if Int(setArray[i]) != 99 {
                    let label = labelArray[i]
                    label.text = String(setArray[i])
                }
            }
            
            //ラベルに乱数を表示させつつ対象の設定情報Arrayをセット
            let tempDispArray =  buttonKind == LOTOPART.NUM3.rawValue ? [0, 1, 2] : [0, 1, 2, 3]
            displayLabel(tempDispArray)
            
            //ラベルを点滅させるタイマースタート
            blinkTm = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "labelTextBlink", userInfo: nil, repeats: true)
        
            //数字点滅状態
            buttonCount = 2
        
        //ロト系共通処理
        } else {
            //範囲変数設定
            var range = 0
            var kind = 0
            
            //クジ別処理
            switch buttonKind {
                case LOTOPART.MINI.rawValue:
                    range = 31
                    kind = 5
                
                case LOTOPART.LOTO6.rawValue:
                    range = 43
                    kind = 6
                
                case LOTOPART.LOTO7.rawValue:
                    range = 37
                    kind = 7
                
                default: break
            }
            
            //serArrayParent情報なし(設定画面開いてない)だったらsetArray系処理はスキップ
            if setArrayParent.count != 0 {
                setArray = setArrayParent[buttonKind - 101]
            }
            
            //設定画面に任意数字をセットされてたら任意数字を、じゃなかったら乱数をセット
            for var i = 0; i < kind; i++ {
                if i < setArray.count {
                    endArray.append(String(setArray[i]))
                } else {
                    endArray.append(String(format:"%02d", Int(arc4random()) % range + 1))
                }
                
                //乱数が重複したら再抽選
                for var j = 0; j < i; j++ {
                    if j != i {
                        if endArray[i] == endArray[j] {
                            endArray.removeAtIndex(i)
                            i--
                            break
                        }
                    }
                }
            }
            
            //ソート
            endArray = endArray.sort { $0 < $1 }
            
            //順次表示アニメーション中はまたボタン操作を無効にする
            animeSwitch = true
            
            //ロト系順次表示タイマースタート
            orderTim = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "orderDisplayLoto", userInfo: nil, repeats: true)
        }
    }
    
    //順次表示
    func orderDisplayLoto()
    {
        //適当乱数Arrayを空にする
        startArray.removeAll()
        
        //また適当乱数生成
        for var i = 0; i < 7; i++ {
            startArray.append(String(format:"%02d", arc4random() % 99))
        }
        
        //カウンタの数値で表示を切り分け　※１段階５フレーム
        if orderCount < 5 {
            displayLabelOrder(0)
        } else if 5 <= orderCount && orderCount < 10 {
            displayLabelOrder(1)
        } else if 10 <= orderCount && orderCount < 15 {
            displayLabelOrder(2)
        } else if 15 <= orderCount && orderCount < 20 {
            displayLabelOrder(3)
        } else if 20 <= orderCount && orderCount < 25 {
            displayLabelOrder(4)
        } else if 25 <= orderCount && orderCount < 30 {
            if buttonKind == LOTOPART.MINI.rawValue {
                orderCount = -1
            } else {
                displayLabelOrder(5)
            }
        } else if 30 <= orderCount && orderCount < 35 {
            if buttonKind == LOTOPART.LOTO6.rawValue {
                orderCount = -1
            } else {
                displayLabelOrder(6)
            }
        } else {
            orderCount = -1
        }
        
        //順次表示が終了したら通常表示処理
        if orderCount < 0 {
            //順次表示用タイマー停止
            if let tempTm = orderTim {
                tempTm.invalidate() //タイマー停止
                orderTim = nil
            }
            
            //表示完了したら最終表示位置へ
            displayLabelLast()
            
            //ラベルを点滅させるタイマースタート
            blinkTm = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "labelTextBlink", userInfo: nil, repeats: true)
            
            //数字点滅状態
            buttonCount = 2
            
            //順次表示アニメーション終了後にボタン操作を有効にする
            animeSwitch = false
        }
        
        //カウントアップ(変数初期化の効果もあり)
        orderCount++
    }
    
    //3回目にボタンを押されたら点滅終了
    func blinkStop()
    {
        //点滅タイマーストップ
        if let tempTm = blinkTm {
            tempTm.invalidate() //タイマー停止
            blinkTm = nil
        }
        
        //点滅終了
        for label in labelArray {
            label.hidden = false
        }
        
        //ここで次に備えてArrayを初期化しとかなあかん
        startArray.removeAll()
        tempStartArray.removeAll()
        endArray.removeAll()
        
        //ボタンカウントを初期化
        buttonCount = 0
    }
    
    //ラベルのテキスト表示を変えるメソッド(右にずれて数字が消えるアニメーション)
    func labelTextClear()
    {
        //ボタン押下時にアニメーションする２桁数字×７を生成(タイマー処理初回時のみ実施)
        if animationCount == 0 {
            //左右アニメーション中は中央寄せ
            labelFirst.textAlignment = NSTextAlignment.Center
            labelSecond.textAlignment = NSTextAlignment.Center
            labelThird.textAlignment = NSTextAlignment.Center
            labelFourth.textAlignment = NSTextAlignment.Center
            labelFifth.textAlignment = NSTextAlignment.Center
            labelSixeth.textAlignment = NSTextAlignment.Center
            labelSeventh.textAlignment = NSTextAlignment.Center
        
            //左右アニメーションよう数値文字列生成
            for var i = 0; i < 7; i++ {
                //[01]〜[99]の乱数生成
                startArray.append(String(format:"%02d", arc4random() % 99 + 1))
                
                //なめらか表現用のArray生成 //最初の要素は２桁目だけで、あとは左側の１桁目と右側の２桁目をガッチャンコ
                if i == 0 {
                    let index = startArray[0].startIndex.advancedBy(1)
                    tempStartArray.append(startArray[0].substringToIndex(index))
                } else {
                    let index1 = startArray[i - 1].startIndex.advancedBy(1)
                    let index2 = startArray[i].startIndex.advancedBy(1)
                    tempStartArray.append(startArray[i - 1].substringToIndex(index1) + startArray[i].substringToIndex(index2))
                }
            }
        }
        
        //左右アニメーション　(Array渡しでちょっとだけスマートに書いてみた)
        switch animationCount {
            case 0,28: //最初はstartArrayの情報をそのまま表示
                labelTextSet(startArray, onOffCount: 0)
            
            case 1,27: //次はなめらかArrayの情報をそのまま表示
                labelTextSet(tempStartArray, onOffCount: 0)
            
            case 2,26: //startArrayを1つずらし
                labelTextSet(startArray, onOffCount: 1)
            
            case 3,25: //なめらかArrayを1つずらし
                labelTextSet(tempStartArray, onOffCount: 1)
            
            case 4,24: //startArrayを2つずらし
                labelTextSet(startArray, onOffCount: 2)
                
            case 5,23: //なめらかArrayを2つずらし
                labelTextSet(tempStartArray, onOffCount: 2)
            
            case 6,22: //startArrayを3つずらし
                labelTextSet(startArray, onOffCount: 3)
                
            case 7,21: //なめらかArrayを3つずらし
                labelTextSet(tempStartArray, onOffCount: 3)
            
            case 8,20: //startArrayを4つずらし
                labelTextSet(startArray, onOffCount: 4)
                
            case 9,19: //なめらかArrayを4つずらし
                labelTextSet(tempStartArray, onOffCount: 4)
            
            case 10,18: //startArrayを5つずらし
                labelTextSet(startArray, onOffCount: 5)
                
            case 11,17: //なめらかArrayを5つずらし
                labelTextSet(tempStartArray, onOffCount: 5)
            
            case 12,16: //startArrayを6つずらし
                labelTextSet(startArray, onOffCount: 6)
                
            case 13,15: //なめらかArrayを6つずらし
                labelTextSet(tempStartArray, onOffCount: 6)
            
            case 14: //全消し
                labelTextSet(tempStartArray, onOffCount: 7)
            
            default: break
        }
        
        //右に消えきって左に出きった数を数える為にカウンターをインクリメント
        animationCount++
        
        //左右アニメーション中は以下の処理はスキップ
        if animationCount <= 30 { return }
        
        //この時点で次に備えてtempStartArrayを初期化
        tempStartArray.removeAll()
        
        //左右アニメーション終了したらカウンター初期化
        animationCount = 0
        
        //tmタイマーストップ
        if let tempTm = tm {
            tempTm.invalidate() //タイマー停止
            tm = nil
        }
        
        //0.5秒待ってから高速回転用タイマースタート
        NSThread.sleepForTimeInterval(0.5)
        
        //ナンバーズは表示AlignmentをLeftに
        if buttonKind == LOTOPART.NUM3.rawValue || buttonKind == LOTOPART.NUM4.rawValue {
            labelFirst.textAlignment = NSTextAlignment.Left
            labelSecond.textAlignment = NSTextAlignment.Left
            labelThird.textAlignment = NSTextAlignment.Left
            labelFourth.textAlignment = NSTextAlignment.Left
            labelFifth.textAlignment = NSTextAlignment.Left
            labelSixeth.textAlignment = NSTextAlignment.Left
            labelSeventh.textAlignment = NSTextAlignment.Left
        }
        
        highTm = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "labelTextHighRevol", userInfo: nil, repeats: true)
        
        //左右アニメーション終了後はボタン操作を有効にするのでスイッチをoff：NO　にしてボタンカウントを１にアップ
        animeSwitch = false
        buttonCount = 1
    }
    
    //ラベルのテキスト高速回転させる
    func labelTextHighRevol()
    {
        //適当乱数Arrayを空にする
        startArray.removeAll()
        
        //ナンバーズ系とロト系は処理が異なる
        switch buttonKind {
            case LOTOPART.NUM3.rawValue, LOTOPART.NUM4.rawValue:
                //ナンバーズ系は４つの一桁乱数を毎回生成
                for var i = 0; i < 4; i++ {
                    startArray.append(String(arc4random() % 9))
                }
            
                //それぞれ表示
                if buttonKind == LOTOPART.NUM3.rawValue {
                    displayLabel([1, 2, 3])
                } else {
                    displayLabel([0, 1, 4, 6])
                }
        
            default:
                //ロト系は７つの二桁乱数を毎回生成
                for var i = 0; i < 7; i++ {
                    startArray.append(String(format:"%02d", arc4random() % 99))
                }
                
                //それぞれ表示
                if buttonKind == LOTOPART.MINI.rawValue {
                    displayLabel([0, 1, 2, 3, 6])
                } else if buttonKind == LOTOPART.LOTO6.rawValue {
                    displayLabel([0, 1, 2, 4, 5, 6])
                } else {
                    displayLabel([0, 1, 2, 3, 4, 5, 6])
                }
            }
    }
    
    //左右アニメーション用ラベル表示メソッド
    func labelTextSet(valueArray: [String], onOffCount: Int)
    {
        //可変Arrayにコピー
        var mutableValueArray = valueArray
        
        //onOffCountだけずらす（lastObjectを削除して前に空文字を追加）
        for var i = 0; i < onOffCount; i++ {
            mutableValueArray.removeLast()
            mutableValueArray.insert("", atIndex: 0)
        }
        
        //ずらしたArrayをラベルに表示
        for var i = 0; i < 7; i++ {
            labelArray[i].text = mutableValueArray[i]
        }
    }

    //高速回転用ラベル表示メソッド
    func displayLabel(displayNum: [Int])
    {
        var j = 0
        for var i = 0; i < 7; i++ {
            if  displayNum.contains(i) { //本当にこのcontainsの使い方で存在チェックできるの？？？？？
                labelArray[i].text = startArray[j]
                j++
            } else {
                labelArray[i].text = ""
            }
        }
    }
    
    //順次表示用ラベル表示メソッド
    func displayLabelOrder(frameCount: Int)
    {
        var localFrameCount = frameCount
        var displayNum: [Int] = []
        if buttonKind == LOTOPART.MINI.rawValue {
            displayNum = [0, 1, 2, 3, 6]
        } else if buttonKind == LOTOPART.LOTO6.rawValue {
            displayNum = [0, 1, 2, 4, 5, 6]
        } else {
            displayNum = [0, 1, 2, 3, 4, 5, 6]
        }

        var j = 0
        for var i = 0; i < 7; i++ {
            if  displayNum.contains(i) { //本当にこのcontainsの使い方で存在チェックできるの？？？？？
                if localFrameCount >= i {
                    labelArray[i].text = endArray[j]
                } else {
                    labelArray[i].text = startArray[j]
                }
                j++
            } else {
                labelArray[i].text = ""
                localFrameCount++
            }
        }
    }
    
    //最終表示ラベル表示メソッド
    func displayLabelLast()
    {
        var displayNum: [Int] = []
        if buttonKind == LOTOPART.MINI.rawValue {
            displayNum = [0, 1, 2, 3, 4]
        } else if buttonKind == LOTOPART.LOTO6.rawValue {
            displayNum = [0, 1, 2, 3, 4, 5]
        } else {
            displayNum = [0, 1, 2, 3, 4, 5, 6]
        }
        
        for var i = 0; i < 7; i++ {
            if  displayNum.contains(i) { //本当にこのcontainsの使い方で存在チェックできるの？？？？？
                labelArray[i].text = endArray[i]
            } else {
                labelArray[i].text = ""
            }
        }
    }
    
    //ラベルテキスト点滅メソッド
    func labelTextBlink()
    {
        for label in labelArray {
            label.hidden = !label.hidden
        }
    }
    
    //設定画面への遷移
    func transSetMode()
    {
        //svcインスタンスが存在しない場合は生成（シングルトン！！）
        if svc == nil {
            svc = SetViewController()
            svc?.delegate = self
        }
        
        //遷移
        if let tempSvc = svc {
            self.presentViewController(tempSvc, animated: true, completion: nil)
        }
    }
    
    
    //設定画面から値を受け渡される方法を調査してから実装？？？？？
    func finishSetting(returnValue: [[Int]])
    {
        //こっちのインスタンス変数にセット
        //num3,num4,mini,loto6,loto7の順番で設定情報Arrayが入ってる
        setArrayParent = returnValue
        
        for var i = 0; i < setArrayParent.count; i++ {
            var kujiKind = setArrayParent[i]
            
            //ナンバーズ系の場合はANY(0)を「99」に変換し、それ以外は「-1」して再セット
            if i < 2 {
                for var i = 0; i < kujiKind.count; i++ {
                    kujiKind[i] = kujiKind[i] == 0 ? 99 : --kujiKind[i]
                }
            } else {
                //ロト系の場合は場合はまずANY(0)を削除して重複削除してソート
                //ANY(0)削除　※単純なカウントアップのfor文だと削除のたびにMutableArrayの要素数が減っていくので不整合が起きる。したがって要素の後ろから順番に削除していく必要がある。
                for var i = kujiKind.count - 1; i >= 0; i-- {
                    if kujiKind[i] == 0 {
                        kujiKind.removeAtIndex(i)
                    }
                }
                
                //重複排除
                for var i = 0; i < kujiKind.count; i++ {
                    var index = 0
                    for tempValue in kujiKind {
                        //配列の中身を比較し、同一かつ現在の数値ではない場合削除する
                        if tempValue == kujiKind[i] && index != i {
                            kujiKind.removeAtIndex(i)
                            i--
                            break
                        }
                        index++
                    }
                }
                //ソート
                kujiKind = kujiKind.sort { $0 < $1 }
            }
        }
    }
    
    
    //ソーシャルボタン押下時の挙動
    func socialButton(button: UIButton)
    {
        //画面キャプチャの取得と90度回転
        var captureImage = MainViewController.getScreenShotImage()
        captureImage = UIImage(CGImage: captureImage.CGImage!, scale: captureImage.scale, orientation: UIImageOrientation.Right)
        
        //Twitter
        if button.tag == SNSPART.TWITTER.rawValue {
            //アカウントチェック
            if !SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                displayAlertMessage("Twitter")
                return
            }
            
            //Twitter投稿画面生成
            let twitter = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitter.setInitialText(makeSnsPostStr())
            twitter.addImage(captureImage)
            self.presentViewController(twitter, animated: true, completion: nil)
        
        //FaceBook
        } else if button.tag == SNSPART.FACEBOOK.rawValue {
            //アカウントチェック
            if !SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                displayAlertMessage("FaceBook")
                return
            }
            
            //FaceBook投稿画面生成
            let facebook = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebook.setInitialText(makeSnsPostStr())
            facebook.addImage(captureImage)
            self.presentViewController(facebook, animated: true, completion: nil)
            
        //LINE
        } else {
            //LINEは最初に文字列生成
            let lineMessage = NSURL(string: "line://msg/text" + makeSnsPostStr())
            
            //インストールチェック
            if !UIApplication.sharedApplication().canOpenURL(lineMessage!) {
                displayAlertMessage("LINE")
                return
            }
            
            //LINE連携　文字と画像は一緒にでけへん
            UIApplication.sharedApplication().openURL(lineMessage!)
        }
    }
    
    //SNS用の文字列生成メソッド
    func makeSnsPostStr() -> String
    {
        //くじの種類文字列生成
        let kujiKindStr: [String] = ["ナンバーズ３", "ナンバーズ４", "ミニロト", "ロト６", "ロト７"]
        let kujiKind = "次回\(kujiKindStr[buttonKind - 101])の予想はこれで決まり！！\n"
        
        //数列文字列生成
        var kujiNum = ""
        for label in labelArray {
            kujiNum += label.text!
            //ナンバーズ系は空白なし
            if !(buttonKind == LOTOPART.NUM3.rawValue || buttonKind == LOTOPART.NUM4.rawValue) {
                kujiNum += " "
            }
        }
        
        //前後の不要な空白をトリム
        kujiNum = kujiNum.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        //最終的に表示する文字列に整形して返す
        return "\(kujiKind)「\(kujiNum)」（買うとは言ってない）#当たる鴨君"
    }
    
    //画面キャプチャクラスメソッド
    static func getScreenShotImage() -> UIImage
    {
        let window = UIApplication.sharedApplication().keyWindow
        
        UIGraphicsBeginImageContextWithOptions(window!.bounds.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        //windowの表示内容を描画
        for tempWindow in UIApplication.sharedApplication().windows {
            tempWindow.layer.renderInContext(context!)
        }
        
        let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return capturedImage
    }
    
    //アラートメッセージ共通メソッド
    func displayAlertMessage(message: String)
    {
        //メッセージを作成
        let localMessage = "iPhoneの設定画面で\(message)アカウントを設定してください"
        
        if #available(iOS 8.0, *) {
            //iOS8以上用のアラート表示処理を書く (UIAlertControllerを使用)
            let alert = UIAlertController(title: "", message: localMessage, preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action) -> Void in}
            alert.addAction(cancelAction)
            presentViewController(alert, animated: true, completion: nil)
        } else {
            //iOS7用のアラート表示処理を書く (UIAlertViewを使用)
            let alert = UIAlertView(title: "", message: localMessage, delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
    }

    //メモリワーニング
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
}
