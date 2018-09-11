//
//  CareButtonView.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2017/12/31.
//  Copyright © 2017 Hiroka Yago. All rights reserved.
//

import UIKit

class CareButtonView: UIView {

    @IBOutlet weak var buttonTopView: UIView!
    @IBOutlet weak var buttonBottomView: UIView!
    @IBOutlet weak var nameLabel: UILabel!

    private var careButton: CareButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configure()
    }

    private func loadNib() {
        let view = Bundle.main.loadNibNamed("CareButtonView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }

    private func configure() {
        loadNib()

        CareButtonViewHelper.configure(buttonTopView)
        CareButtonViewHelper.configure(buttonBottomView)
        nameLabel.adjustsFontSizeToFitWidth = true
    }

    func set(careButton: CareButton) {
        self.careButton = careButton

        self.nameLabel.text = careButton.name
        self.buttonTopView.backgroundColor = careButton.colorType
        self.buttonBottomView.backgroundColor = careButton.colorType.darken()
    }

}
