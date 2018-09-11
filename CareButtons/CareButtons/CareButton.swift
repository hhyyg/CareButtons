//
//  CareButton.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/03/04.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import Foundation
import UIKit

//ボタン
struct CareButton {
    private static let defaultAmount: Decimal = 120

    var id: String = UUID().uuidString
    var name: String
    var description: String?
    var colorType: UIColor
    /// 数量を保持するか
    var hasAmount: Bool = false
    /// ユニット名
    var amountUnitName: String?
    /// ノートを持つか
    var hasNote: Bool = false

    /// ボタンをタップしたときに、何か情報入力が必要かどうか
    var requireInputAdditionalInfo: Bool {
        return (hasNote || hasAmount)
    }

    init(
        name: String,
        description: String?,
        colorType: UIColor) {

        self.init(name: name, description: description, colorType: colorType, hasAmount: false, amountUnitName: nil, hasNote: false)
    }

    init(
        name: String,
        description: String?,
        colorType: UIColor,
        hasAmount: Bool,
        amountUnitName: String?,
        hasNote: Bool) {

        self.name = name
        self.description = description
        self.colorType = colorType

        self.hasAmount = hasAmount
        self.amountUnitName = amountUnitName
        self.hasNote = hasNote
    }

    func toPanel() -> CareButtonPanel {
        return CareButtonPanel(button: self, operation: .normal)
    }

    //数量の初期値を取得する
    func getDefaultAmount() -> Decimal {
        if !hasAmount {
            assertionFailure("invalid method")
        }

        let defaults = AppUserDefaults.get()
        return defaults.careButtonAmountInitialValue[id] ?? CareButton.defaultAmount
    }

    //数量の初期値を保存
    func setDefaultAmount(amount: Decimal) {
        var defaults = AppUserDefaults.get()
        defaults.careButtonAmountInitialValue[id] = amount
        defaults.save()
    }

}
