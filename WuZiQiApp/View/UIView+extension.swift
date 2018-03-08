//
//  UIView+extension.swift
//  WuZiQiApp
//
//  Created by Wenba on 2018/3/7.
//  Copyright © 2018年 Wenba. All rights reserved.
//

import Foundation
import UIKit

private var key : Void?
extension UIView {
    var coordincate : (x : Int,y : Int)? {
        get {
            return objc_getAssociatedObject(self , &key) as? (x : Int,y : Int)
        }
        set(newValue) {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
