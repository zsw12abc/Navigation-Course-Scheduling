//
//  Calendar.swift
//  Navigation Course Scheduling
//
//  Created by ShaoweiZhang on 15/10/30.
//  Copyright © 2015年 ShaoweiZhang. All rights reserved.
//

import UIKit


class Calendar {
    var zs:Int, ys:Int, xs:Int
    var matrix: [Int]
    
    
    init(zs: Int, ys:Int, xs:Int) {
        self.zs = zs
        self.ys = ys
        self.xs = xs
        matrix = Array(count:zs*ys*xs, repeatedValue:0)
    }
    
    subscript(z:Int, ys:Int, xs:Int) -> Int {
        get {
            return matrix[ zs * ys * xs + ys ]
        }
        set {
            matrix[ zs * ys * xs + ys ] = newValue
        }
    }
    
    func zsCount() -> Int {
        return self.zs
    }
    
    func colCount() -> Int {
        return self.ys
    }
    
    func rowCount() -> Int {
        return self.xs
    }
}