//
//  CareButtonActionSelectTimeTableViewCell.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/01/01.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import UIKit

class CareButtonActionSelectTimeTableViewCell: UITableViewCell {

    static let cellIdentifier = "CareButtonActionSelectTimeTableViewCell"
    private weak var delegate: CareButtonActionSelectTimeTableViewCellProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionStyle = .none
    }

    func set(delegate: CareButtonActionSelectTimeTableViewCellProtocol) {
        self.delegate = delegate
    }

    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        delegate?.selectTimeDatePicker(self, valueChanged: sender.date)
    }

}

protocol CareButtonActionSelectTimeTableViewCellProtocol: class {
    func selectTimeDatePicker(_ viewCell: CareButtonActionSelectTimeTableViewCell, valueChanged date: Date)
}
