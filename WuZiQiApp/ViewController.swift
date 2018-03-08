//
//  ViewController.swift
//  WuZiQiApp
//
//  Created by Wenba on 2018/3/6.
//  Copyright © 2018年 Wenba. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var chessBoard: ChessBoardView!
    override func viewDidLoad() {
        super.viewDidLoad()
        chessBoard.block = {[weak self](value) in
            guard self != nil else {
                return
            }
            let tips = value ? "黑方" : "白方"
            self!.tipsLabel.text = "\(tips) 执棋"
        }
        chessBoard.overBlock = {[weak self](value) in
            guard self != nil else {
                return
            }
            let tips = value ? "黑方" : "白方"
            self!.tipsLabel.text = "\(tips) 获胜!"
        }
    }

    @IBAction func cancelChess(_ sender: Any) {
            tipsLabel.text = "不带悔棋!"
    }
    
    @IBAction func startNewGame(_ sender: Any) {
        chessBoard.newGame()
        tipsLabel.text = "NewGame.."
    }
    
}

