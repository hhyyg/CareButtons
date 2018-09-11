//
//  SharedUserTableViewCell.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/04/09.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import UIKit

class SharedUserTableViewCell: UITableViewCell {

    static let cellIdentifier = "SharedUserTableViewCell"

    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func set(sharedUser: SharedUser) {
        nameLabel.text = "@\(sharedUser.twitterId)"
    }
}
