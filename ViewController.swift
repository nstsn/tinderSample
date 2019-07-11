//
//  ViewController.swift
//  a
//
//  Created by 鴻巣太一 on 2019/07/05.
//  Copyright © 2019 Taichi Konosu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//  storyboad上のオブジェクトとの紐付け(basiccard(一番メインのカード))
    @IBOutlet weak var basicCard: UIView!
//  storyboad上のオブジェクトとの紐付け(goodImage(いいねボタン))
    @IBOutlet weak var likeImageView: UIImageView!
    
    
    @IBOutlet weak var person1: UIView!
    @IBOutlet weak var person2: UIView!
    @IBOutlet weak var person3: UIView!
    @IBOutlet weak var person4: UIView!
    
    var centerOfCard: CGPoint!
    var people = [UIView]()
    var selectedCardCount: Int = 0
    
    let name = ["ほのか", "あかね", "みほ", "カルロス"]
    var likedName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerOfCard = basicCard.center
        people.append(person1)
        people.append(person2)
        people.append(person3)
        people.append(person4)
        
    }
    
    func resetCard() {
        basicCard.center = self.centerOfCard
        basicCard.transform = .identity

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushList" {
            let vc = segue.destination as! ListViewController
            vc.likedName = likedName
        }
    }
   
//    likeボタンがタップされた時
    @IBAction func likebuttonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.resetCard()
            self.people[self.selectedCardCount].center = CGPoint(x: self.people[self.selectedCardCount].center.x + 500, y: self.people[self.selectedCardCount].center.y)
        })
        likedName.append(name[selectedCardCount])
        selectedCardCount += 1
        likeImageView.alpha = 0
        if selectedCardCount >= people.count {
            performSegue(withIdentifier: "PushList", sender: self)
        }
    }
    
//    dislikeボタンがタップされた時
    @IBAction func dislikebuttonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.resetCard()
            self.people[self.selectedCardCount].center = CGPoint(x: self.people[self.selectedCardCount].center.x - 500, y: self.people[self.selectedCardCount].center.y)
        })
        selectedCardCount += 1
        likeImageView.alpha = 0
        if selectedCardCount >= people.count {
            performSegue(withIdentifier: "PushList", sender: self)
        }
    }
    
//  storyboad上のオブジェクトとの紐付け(Pan Gesture Recognizer)
//  swipeを検知するメソッド
    @IBAction func swipeCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        
    //  ドラッグ&ドロップしている間ずっとカードが動く処理
    //  初期値(card.center)に動いた分のx,y座標を足している
        card.center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        people[selectedCardCount].center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        
        
    //  cardのx座標に対してcardの角度を変えるための変数
        let xFromCenter = card.center.x - view.center.x
        
//      規定値になったら画像を表示、透明度を上げ、色を変える
        if xFromCenter > 0 {
//          アセットから画像の参照：「Image Literal」→ダブルクリック（Xcode10の仕様っぽい）
            likeImageView.image = #imageLiteral(resourceName: "good")
            likeImageView.alpha = 1
            likeImageView.tintColor = UIColor.red
        }   else if xFromCenter < 0 {
            likeImageView.image = #imageLiteral(resourceName: "bad")
            likeImageView.alpha = 1
            likeImageView.tintColor = UIColor.blue
        }
    //  ラジアンで表している（わからなすぎる...）
        card.transform = CGAffineTransform(rotationAngle: xFromCenter / (view.frame.width / 2) * -0.785)
        people[selectedCardCount].transform = CGAffineTransform(rotationAngle: xFromCenter / (view.frame.width / 2) * -0.785)
        
    //  ドラッグ&ドロップを終えて指を離したときの処理UIGestureRecognizer.State.ended
        if sender.state == UIGestureRecognizer.State.ended {
            
    //      左に大きくスワイプ(bad)
            if card.center.x < 50 {
//              ＊クロージャ：引数として呼び出せる関数みたいなやつ。
//              アニメーション処理(センターに戻る時を対象として0.2秒のアニメーション)
                UIView.animate(withDuration: 0.2, animations: {
                    self.resetCard()
                    self.people[self.selectedCardCount].center = CGPoint(x: self.people[self.selectedCardCount].center.x - 250, y: self.people[self.selectedCardCount].center.y)
                })
                selectedCardCount += 1
                likeImageView.alpha = 0
                if selectedCardCount >= people.count {
                    performSegue(withIdentifier: "PushList", sender: self)
                }
    //          returnで一時的に処理を抜ける(?)
                return
            }  //   右に大きくスワイプ(like)
            else if card.center.x > self.view.frame.width - 50 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.resetCard()
                    self.people[self.selectedCardCount].center = CGPoint(x: self.people[self.selectedCardCount].center.x + 250, y: self.people[self.selectedCardCount].center.y)
                })
                likedName.append(name[selectedCardCount])   
                selectedCardCount += 1
                likeImageView.alpha = 0
                if selectedCardCount >= people.count {
                    performSegue(withIdentifier: "PushList", sender: self)
                }
                return
            }
    //      元に戻る処理
    //      self.と記述してViewControllerであることを指定しておかないとエラーが起きる
            UIView.animate(withDuration: 0.2, animations: {
                  self.resetCard()
                  self.people[self.selectedCardCount].center  = self.centerOfCard
                  self.people[self.selectedCardCount].transform = .identity
            })
            likeImageView.alpha = 0
            
        }
        
    }
    
}
