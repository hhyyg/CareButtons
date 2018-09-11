//
//  InviteCodeTableViewCell.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/04/09.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import UIKit
import RxSwift
import NativePopup

class InviteCodeTableViewCell: UITableViewCell {

    static let cellIdentifier = "InviteCodeTableViewCell"
    private let disposeBag = DisposeBag()

    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var qrCodeImage: UIImageView!
}
