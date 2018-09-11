//
//  Circle.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2017/12/29.
//  Copyright © 2017 Hiroka Yago. All rights reserved.
//

import UIKit

class CircleView: UIView {

    var color: UIColor = UIColor.gray

    override func draw(_ rect: CGRect) {

        let x = self.bounds.width / 2
        let y = self.bounds.height / 2

        let circle = UIBezierPath(ovalIn: CGRect(x: x - 5, y: y - 5, width: 10, height: 10))
        //塗りつぶし
        color.setFill()
        circle.fill()

        //stroke
        color.setStroke()
        circle.lineWidth = 1

        circle.stroke()

    }

}
