//
//  CareButtonEventLog.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/03/04.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import Foundation
import UIKit

struct CareButtonEventLog {
    //イベントを起こしたCareButton
    let baseCareButton: CareButton?

    var time: Date
    let name: String
    let description: String?
    let colorType: UIColor

    var amount: Decimal?
    var amountUnitName: String?
    var note: String?

    init (baseCareButton: CareButton) {
        self.init(
            baseCareButton: baseCareButton,
            time: Date(),
            name: baseCareButton.name,
            description: baseCareButton.description,
            colorType: baseCareButton.colorType,
            amount: nil,
            amountUnitName: nil)
    }

    //数量付き
    init(baseCareButton: CareButton,
         amount: Decimal) {

        guard let amountUnitName = baseCareButton.amountUnitName else {
            fatalError("baseCareButton.amountUnitName is required")
        }

        self.init(
            baseCareButton: baseCareButton,
            time: Date(),
            name: baseCareButton.name,
            description: baseCareButton.description,
            colorType: baseCareButton.colorType,
            amount: amount,
            amountUnitName: amountUnitName)
    }

    init(baseCareButton: CareButton?,
         time: Date,
         name: String,
         description: String?,
         colorType: UIColor,
         amount: Decimal? = nil,
         amountUnitName: String? = nil,
         note: String? = nil) {

        self.baseCareButton = baseCareButton
        self.time = time
        self.name = name
        self.description = description
        self.colorType = colorType
        self.amount = amount
        self.amountUnitName = amountUnitName
        self.note = note
    }

    private static let timeFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    func timeText() -> String {
        return CareButtonEventLog.timeFormatter.string(from: time)
    }

}

extension CareButtonEventLog {

    func asDictionary() -> [String: Any] {

        return [
            "time": time,
            "name": name,
            "description": description as Any,
            "colorType": NSKeyedArchiver.archivedData(withRootObject: colorType),
            "amount": amount as Any,
            "amountUnitName": amountUnitName as Any,
            "note": note as Any
        ]

    }

}
