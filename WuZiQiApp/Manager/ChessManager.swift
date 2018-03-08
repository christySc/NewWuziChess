//
//  ChessManager.swift
//  WuZiQiApp
//
//  Created by Wenba on 2018/3/6.
//  Copyright © 2018年 Wenba. All rights reserved.
//

import UIKit

enum Direction {
    case 上
    case 下
    case 左
    case 右
    case 左上
    case 左下
    case 右上
    case 右下
}


class ChessManager: NSObject {
    public static let shared = ChessManager()
    
    lazy var whiteChessArray : [(x : Int,y : Int)] = []
    lazy var blackChessArray : [(x : Int,y : Int)] = []
    var isOver = false
  
    //计算棋子位置并添加进入妻子队列
    func calculateChessLoactaion(isBlack : Bool,element : (x : Int,y : Int)) -> Bool {
        guard element.x <= 15 && element.y <= 15 else {
            return false
        }
        if blackChessArray.contains(where: {$0.x == element.x && $0.y == element.y}){
            return false
        }
        if whiteChessArray.contains(where: {$0.x == element.x && $0.y == element.y}){
            return false
        }
        
        if isBlack {
            blackChessArray.append(element)
            return true
        }else {
            whiteChessArray.append(element)
            return true
        }
    }
    
    func judgeResult(isBlack : Bool, ifWin : ([(x : Int,y : Int)]) -> ()) {
        var tmpArray = isBlack ? blackChessArray : whiteChessArray
        guard tmpArray.count >= 5 else {
            return
        }
        let element = tmpArray.last
        tmpArray.remove(at: tmpArray.count - 1)
        let str = isBlack ? "黑方" : "白方"
        if calculateChessCount(chessCoordinate: element!, direction: .上, sourceArray: tmpArray) + calculateChessCount(chessCoordinate: element!, direction: .下, sourceArray: tmpArray) > 5 {
           print("\(str)竖直获胜")
            ifWin(alertResult(.上, isBlack: isBlack))
            return
        }
        
        if calculateChessCount(chessCoordinate: element!, direction: .左, sourceArray: tmpArray) + calculateChessCount(chessCoordinate: element!, direction: .右, sourceArray: tmpArray) > 5 {
            print("\(str)水平获胜")
            ifWin(alertResult(.左, isBlack: isBlack))
            return
        }
        
        if calculateChessCount(chessCoordinate: element!, direction: .左上, sourceArray: tmpArray) + calculateChessCount(chessCoordinate: element!, direction: .右下, sourceArray: tmpArray) > 5 {
            print("\(str)斜获胜")
            ifWin(alertResult(.左上, isBlack: isBlack))
            return
        }
        
        if calculateChessCount(chessCoordinate: element!, direction: .右上, sourceArray: tmpArray) + calculateChessCount(chessCoordinate: element!, direction: .左下, sourceArray: tmpArray) > 5 {
            print("\(str)斜获胜")
            ifWin(alertResult(.右上, isBlack: isBlack))
            return
        }
        
    }
    
        func calculateChessCount(chessCoordinate : (x : Int,y : Int), direction : Direction = .上, sourceArray : [(x : Int,y : Int)],input : Int = 1) -> Int{
        var result = 0
        let array = sourceArray
        result += input
        switch direction {
        case .上:
                if array.filter({ (element) -> Bool in
                    return element.x == chessCoordinate.x && element.y == chessCoordinate.y - 1
                }).count > 0 {
                    result += 1
                    let arr = array.filter({ (element) -> Bool in
                        return element.x == chessCoordinate.x && element.y == chessCoordinate.y - 1
                    })[0]
                    return calculateChessCount(chessCoordinate: arr, direction: .上, sourceArray: sourceArray, input: result)
                }else {
                    return result
            }
        case .下:
            if array.filter({ (element) -> Bool in
                return element.x == chessCoordinate.x && element.y == chessCoordinate.y + 1
            }).count > 0 {
                result += 1
                let arr = array.filter({ (element) -> Bool in
                    return element.x == chessCoordinate.x && element.y == chessCoordinate.y + 1
                })[0]
                return calculateChessCount(chessCoordinate: arr, direction: .下, sourceArray: sourceArray, input: result)
            }else {
                return result
            }
        case .左:
            if array.filter({ (element) -> Bool in
                return element.x == chessCoordinate.x - 1 && element.y == chessCoordinate.y
            }).count > 0 {
                result += 1
                let arr = array.filter({ (element) -> Bool in
                    return element.x == chessCoordinate.x - 1 && element.y == chessCoordinate.y
                })[0]
                return calculateChessCount(chessCoordinate: arr, direction: .左, sourceArray: sourceArray, input: result)
            }else {
                return result
            }
        case .右:
            if array.filter({ (element) -> Bool in
                return element.x == chessCoordinate.x + 1 && element.y == chessCoordinate.y
            }).count > 0 {
                result += 1
                let arr = array.filter({ (element) -> Bool in
                    return element.x == chessCoordinate.x + 1 && element.y == chessCoordinate.y
                })[0]
                return calculateChessCount(chessCoordinate: arr, direction: .右, sourceArray: sourceArray, input: result)
            }else {
                return result
            }
        case .左上:
            if array.filter({ (element) -> Bool in
                return element.x == chessCoordinate.x - 1 && element.y == chessCoordinate.y - 1
            }).count > 0 {
                result += 1
                let arr = array.filter({ (element) -> Bool in
                    return element.x == chessCoordinate.x - 1 && element.y == chessCoordinate.y - 1
                })[0]
                return calculateChessCount(chessCoordinate: arr, direction: .左上, sourceArray: sourceArray, input: result)
            }else {
                return result
            }
        case .左下:
            if array.filter({ (element) -> Bool in
                return element.x == chessCoordinate.x - 1 && element.y == chessCoordinate.y + 1
            }).count > 0 {
                result += 1
                let arr = array.filter({ (element) -> Bool in
                    return element.x == chessCoordinate.x - 1 && element.y == chessCoordinate.y + 1
                })[0]
                return calculateChessCount(chessCoordinate: arr, direction: .左下, sourceArray: sourceArray, input: result)
            }else {
                return result
            }
        case .右上:
            if array.filter({ (element) -> Bool in
                return element.x == chessCoordinate.x + 1 && element.y == chessCoordinate.y - 1
            }).count > 0 {
                result += 1
                let arr = array.filter({ (element) -> Bool in
                    return element.x == chessCoordinate.x + 1 && element.y == chessCoordinate.y - 1
                })[0]
                return calculateChessCount(chessCoordinate: arr, direction: .右上, sourceArray: sourceArray, input: result)
            }else {
                return result
            }
        case .右下:
            if array.filter({ (element) -> Bool in
                return element.x == chessCoordinate.x + 1 && element.y == chessCoordinate.y + 1
            }).count > 0 {
                result += 1
                let arr = array.filter({ (element) -> Bool in
                    return element.x == chessCoordinate.x + 1 && element.y == chessCoordinate.y + 1
                })[0]
                return calculateChessCount(chessCoordinate: arr, direction: .右下, sourceArray: sourceArray, input: result)
            }else {
                return result
            }
        }
       
    }
    
    func alertResult(_ direction : Direction, isBlack : Bool) -> [(x : Int,y : Int)] {
        let array = isBlack ? blackChessArray : whiteChessArray
        let element = (array.last)!
        var resultArray : [(x : Int,y : Int)] = []
        switch direction {
        case .上,.下:
            let tmpArray = array.filter({ (coordinate) -> Bool in
                return coordinate.x == element.x
            }).sorted(by: { (coor1, coor2) -> Bool in
                return abs(coor1.y - element.y) < abs(coor2.y - element.y)
            })
            let sliceArray = tmpArray[0..<5]
            resultArray = Array(sliceArray)
        case .左,.右:
            let tmpArray = array.filter({ (coordinate) -> Bool in
                return coordinate.y == element.y
            }).sorted(by: { (coor1, coor2) -> Bool in
                return abs(coor1.x - element.x) < abs(coor2.x - element.x)
            })
            let sliceArray = tmpArray[0..<5]
            resultArray = Array(sliceArray)
        case .左上,.右下:
            let tmpArray = array.filter({ (coordinate) -> Bool in
                return  (((coordinate.x <= element.x) && (coordinate.y <= element.y)) || ((coordinate.x >= element.x) && (coordinate.y >= element.y))) && ((element.x - element.y) == (coordinate.x - coordinate.y))
            }).sorted(by: { (coor1, coor2) -> Bool in
                return abs(coor1.x - element.x) < abs(coor2.x - element.x)
            })
            let sliceArray = tmpArray[0..<5]
            resultArray = Array(sliceArray)
        case .右上,.左下:
            
            let tmpArray = array.filter({ (coordinate) -> Bool in
                return  (((coordinate.x >= element.x) && (coordinate.y <= element.y)) || ((coordinate.x <= element.x) && (coordinate.y >= element.y))) && ((element.x + element.y) == (coordinate.x + coordinate.y))
            }).sorted(by: { (coor1, coor2) -> Bool in
                return abs(coor1.x - element.x) < abs(coor2.x - element.x)
            })
            let sliceArray = tmpArray[0..<5]
            resultArray = Array(sliceArray)
        }
        return resultArray
    }
  

}
