//
//  TimelineTableViewCell.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2017/12/29.
//  Copyright © 2017 Hiroka Yago. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {

    private static let containerViewRadius: CGFloat = 6

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var CircleView: CircleView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountUnitNameLabel: UILabel!

    @IBOutlet weak var noteContainer: UIView!
    @IBOutlet weak var noteLabel: UILabel!

    private var eventLog: CareButtonEventLog!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func set(_ eventLog: CareButtonEventLog) {
        self.eventLog = eventLog

        timeLabel.text = eventLog.timeText()
        nameLabel.text = eventLog.name
        CircleView.color = eventLog.colorType

        if let amount = eventLog.amount {
            amountLabel.text = amount.description
        } else {
            amountLabel.text = ""
        }
        amountUnitNameLabel.text = eventLog.amountUnitName ?? ""

        //メモエリアを表示するかどうか
        self.noteContainer.isHidden = (eventLog.note == nil)
        //コメント
        self.noteLabel?.text = eventLog.note
    }

}
