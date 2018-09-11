//
//  CareButtonViewHelper.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2017/12/31.
//  Copyright © 2017 Hiroka Yago. All rights reserved.
//

import Foundation
import UIKit

class CareButtonViewHelper {

    static let careButtonRadius: CGFloat = 6

    static func configure(_ buttonView: UIView) {
        buttonView.layer.cornerRadius = careButtonRadius
        buttonView.layer.masksToBounds = true
    }

}
