//
//  CareButtonEventLogParser.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/02/01.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import Foundation
import UIKit

class CareButtonEventLogParser {

    static func parse(dic: [String: Any]) -> CareButtonEventLog? {

        guard let time = dic["time"] as? Date else {
            return nil
        }

        guard let name = dic["name"] as? String else {
            return nil
        }

        let description = dic["description"] as? String
        //TODO: ひとまず固定のカラー
        let colorType: UIColor = UIColor.CareButton.blue
        var amount: Decimal? = nil
        if let amountValue = dic["amount"] as? Double {
            amount = Decimal(amountValue)
        }
        let amountUnitName = dic["amountUnitName"] as? String
        let note = dic["note"] as? String

        let log = CareButtonEventLog(
            baseCareButton: nil,
            time: time,
            name: name,
            description: description,
            colorType: colorType,
            amount: amount,
            amountUnitName: amountUnitName,
            note: note)

        return log
    }

}
