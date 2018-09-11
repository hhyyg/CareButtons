//
//  CareButtonDummyData.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2017/12/27.
//  Copyright © 2017 Hiroka Yago. All rights reserved.
//

import Foundation
import UIKit

class CareButtonDummyData {
    static let shared = CareButtonDummyData()
    private init() {}

    private func getData() -> [CareButton] {

        return [
            CareButton(name: "🍼", description: "ミルク", colorType: UIColor.CareButton.red, hasAmount: true, amountUnitName: "ml", hasNote: false),
            CareButton(name: "💩", description: "うんち", colorType: UIColor.CareButton.blue),
            CareButton(name: "⚖体重", description: "", colorType: UIColor.CareButton.yellow, hasAmount: true, amountUnitName: "kg", hasNote: false),
            CareButton(name: "🤱左", description: "母乳左", colorType: UIColor.CareButton.red, hasAmount: true, amountUnitName: "分", hasNote: false),
            CareButton(name: "🤱右", description: "母乳右", colorType: UIColor.CareButton.red, hasAmount: true, amountUnitName: "分", hasNote: false),
            CareButton(name: "🍼搾", description: "搾母乳", colorType: UIColor.CareButton.red, hasAmount: true, amountUnitName: "ml", hasNote: false),
            CareButton(name: "😪", description: "寝る", colorType: UIColor.CareButton.green),
            CareButton(name: "🌅", description: "起きる", colorType: UIColor.CareButton.green),
            CareButton(name: "💧", description: "おしっこ", colorType: UIColor.CareButton.blue),
            CareButton(name: "💧💩", description: "おしっこ＆うんち", colorType: UIColor.CareButton.blue),
            CareButton(name: "🌡体温", description: "", colorType: UIColor.CareButton.yellow, hasAmount: true, amountUnitName: "度", hasNote: false),
            CareButton(name: "👶身長", description: "", colorType: UIColor.CareButton.yellow, hasAmount: true, amountUnitName: "cm", hasNote: false),
            CareButton(name: "🛀", description: "お風呂", colorType: UIColor.CareButton.yellow),
            CareButton(name: "✍️", description: "メモ", colorType: UIColor.CareButton.green, hasAmount: false, amountUnitName: nil, hasNote: true),
            CareButton(name: "🌸記念", description: "", colorType: UIColor.CareButton.green, hasAmount: false, amountUnitName: nil, hasNote: true),
            CareButton(name: "🚺", description: "トイレ", colorType: UIColor.CareButton.red)
        ]

    }

    func getData() -> [CareButtonPanel] {
        var data = getData().map { (button: CareButton) in
            return button.toPanel()
        }

        data.append(CareButtonPanel.addPanel())

        return data
    }

    func getShortcutPanel() -> [CareButtonPanel] {
        let data = getData()
            .map { (button: CareButton) in
                return button.toPanel()
            }
            .prefix(4)
        return Array(data)
    }
}
