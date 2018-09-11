//
//  CareButtonPanel.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/03/04.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import Foundation

//ボタンinおすところ
struct CareButtonPanel {
    var button: CareButton?
    var operation: CareButtonPanelOperation

    static func addPanel() -> CareButtonPanel {
        return CareButtonPanel(button: nil, operation: .add)
    }
}

enum CareButtonPanelOperation {
    case normal
    case add
}
