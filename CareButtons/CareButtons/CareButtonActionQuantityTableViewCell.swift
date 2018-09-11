//
//  CareButtonActionQuantityTableViewCell.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/01/01.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import UIKit

class CareButtonActionQuantityTableViewCell: UITableViewCell {

    static let cellIdentifier = "CareButtonActionQuantityTableViewCell"

    private weak var delegate: CareButtonActionQuantityTableViewCellProtocol?

    @IBOutlet weak var amountUnitLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountStepper: UIStepper!

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none

        amountStepper.stepValue = 10
        amountStepper.maximumValue = 500
        amountStepper.minimumValue = 0
        stepperValueChanged(amountStepper)
    }

    @IBAction func stepperValueChanged(_ sender: UIStepper) {

        UIView.transition(
            with: self.amountLabel,
            duration: 0.1,
            options: .transitionCrossDissolve,
            animations: { [weak self] in
                self?.amountLabel.text = String(format: "%g", sender.value)
                self?.amountLabel.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            },
            completion: { _ in
                self.amountLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })

        delegate?.quantity(self, valueChanged: Decimal(sender.value))
    }

    func set(delegate: CareButtonActionQuantityTableViewCellProtocol) {
        self.delegate = delegate
    }

    func set(amount: Decimal, amountUnitName: String) {

        amountStepper.value = Double(truncating: amount as NSNumber)
        stepperValueChanged(amountStepper)

        amountUnitLabel.text = amountUnitName
    }

}

protocol CareButtonActionQuantityTableViewCellProtocol: class {
    func quantity(_ viewCell: CareButtonActionQuantityTableViewCell, valueChanged value: Decimal)
}
