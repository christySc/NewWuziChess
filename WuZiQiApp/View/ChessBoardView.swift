//
//  CheckBoardView.swift
//  WuZiQiApp
//
//  Created by Wenba on 2018/3/6.
//  Copyright © 2018年 Wenba. All rights reserved.
//

import UIKit

class ChessBoardView : UIView {
    
    let boardSpace : CGFloat = 20 //空隙
    let boardLineWidth : CGFloat = 0.8 //线宽
    let baseSpace : CGFloat = 10.0 //基础间隔
    
    let manager = ChessManager.shared
    
    var block : ((Bool) -> ())?
    var overBlock : ((Bool) -> ())?
    
    var isBlack = true {
        didSet {
            if !manager.isOver {
              self.block?(isBlack)
            }
           
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.tapBoard(_:))))
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.tapBoard(_:))))
    }
 
    //MARK:UI
    func setUpUI() {
        self.backgroundColor = UIColor(red: 200/255.0, green: 160/255.0, blue: 130/255.0, alpha: 1)
        UIGraphicsBeginImageContext(self.frame.size)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setLineWidth(boardLineWidth)
        for i in 0...15 {
            //竖线
            ctx?.move(to: CGPoint(x: baseSpace + CGFloat(i)*(boardSpace + boardLineWidth), y: baseSpace))
            ctx?.addLine(to: CGPoint(x: baseSpace + CGFloat(i)*(boardSpace + boardLineWidth), y: self.frame.height - baseSpace))
            
            //横线
            ctx?.move(to: CGPoint(x: baseSpace, y: baseSpace + CGFloat(i)*(boardSpace + boardLineWidth)))
            ctx?.addLine(to: CGPoint(x: self.frame.width - baseSpace, y: baseSpace + CGFloat(i)*(boardSpace + boardLineWidth)))
        }
        ctx?.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        let imageView = UIImageView(image: image)
        self.addSubview(imageView)
        UIGraphicsEndImageContext()
    }
    
    //棋子
    func chess() -> UIView {
        let chessView = UIView(frame: CGRect(x: 0, y: 0, width: 15.0, height: 15.0))
        chessView.backgroundColor = isBlack ? UIColor.black : UIColor.white
        chessView.layer.cornerRadius = 7.5
        return chessView
    }
    //MARK:ACTION
    //下棋
    @objc func tapBoard(_ tap : UITapGestureRecognizer) {
        if !manager.isOver {
            let originalPoint = tap.location(in: tap.view)
            
            let coordinate = (x : lroundf(Float((originalPoint.x - baseSpace)/(boardSpace + boardLineWidth))),y : lroundf(Float((originalPoint.y - baseSpace)/(boardSpace + boardLineWidth))))
            
            if manager.calculateChessLoactaion(isBlack: isBlack, element: coordinate) {
                let view = self.chess()
                view.center = CGPoint.init(x: (CGFloat(coordinate.x)*(boardSpace + boardLineWidth) + baseSpace), y: (CGFloat(coordinate.y)*(boardSpace + boardLineWidth) + baseSpace))
                view.coordincate = coordinate
                self.addSubview(view)
                manager.judgeResult(isBlack: isBlack, ifWin: { [weak self](winArray) in
                    guard self != nil else {return}
                    for element in winArray {
                        let resultView = self!.subviews.first(where: { (view) -> Bool in
                            if let coordincate = view.coordincate {
                                return coordincate.x == element.x && coordincate.y == element.y
                            }
                            return false
                        })
                        if let resultView = resultView {
                            let ani = CAKeyframeAnimation()
                            ani.values = [0,1,0]
                            ani.keyPath = "opacity"
                            ani.duration = 0.8
                            ani.repeatCount = MAXFLOAT
                            resultView.layer.add(ani, forKey: "alpha")
                        }
                    }
                    self!.manager.isOver = true
                    self!.overBlock?(isBlack)
                })
                isBlack = !isBlack
            }
        }
        
    }
    
    public func newGame() {
        self.manager.isOver = false
        self.manager.blackChessArray = []
        self.manager.whiteChessArray = []
        self.isBlack = true
        for view in self.subviews {
            if view.coordincate != nil {
                view.removeFromSuperview()
            }
        }
    }

}
