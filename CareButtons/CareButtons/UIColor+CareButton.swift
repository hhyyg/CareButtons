//
//  CareButtonColorType.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2017/12/27.
//  Copyright © 2017 Hiroka Yago. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    var rgb: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let components = cgColor.components!
        return (red: components[0], green: components[1], blue: components[2], alpha: components[3])
    }

    func darken(ratio: CGFloat = CareButton.shadowRatio) -> UIColor {
        assert(ratio >= 1)
        let rgb = self.rgb
        let shadowR = rgb.red.darken(ratio: ratio)
        let shadowG = rgb.green.darken(ratio: ratio)
        let shadowB = rgb.blue.darken(ratio: ratio)

        return UIColor(red: shadowR, green: shadowG, blue: shadowB, alpha: 1.0)
    }

    struct CareButton {

        static let shadowRatio: CGFloat = 3.5

        static let red = UIColor(named: "red")!
        static let blue = UIColor(named: "blue")!
        static let yellow = UIColor(named: "yellow")!
        static let green = UIColor(named: "green")!

    }

}

extension CGFloat {
    fileprivate func darken(ratio: CGFloat) -> CGFloat { return self - self / ratio }
}
