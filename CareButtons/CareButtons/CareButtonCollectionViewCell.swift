//
//  CareButtonCollectionViewCell.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2017/12/27.
//  Copyright © 2017 Hiroka Yago. All rights reserved.
//

import UIKit

protocol CareButtonCollectionViewCellDelegate: class {
    //tap cell
    func careButtonCollectionViewCell(_ viewCell: CareButtonCollectionViewCell)
}

class CareButtonCollectionViewCell: UICollectionViewCell {

    enum Place {
        case app
        case todayExtension
    }

    private static let animationDuration = 0.09
    private static let buttonOnColorRatio: CGFloat = 5.5

    @IBOutlet weak var buttonTopView: UIView!
    @IBOutlet weak var buttonBottomView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var buttonTopView_Top_Constraint: NSLayoutConstraint!

    private(set) var careButtonPanel: CareButtonPanel!
    private weak var delegate: CareButtonCollectionViewCellDelegate?

    var place = Place.app

    override func awakeFromNib() {
        super.awakeFromNib()

        configure()
    }

    private func configure() {
        CareButtonViewHelper.configure(buttonTopView)
        CareButtonViewHelper.configure(buttonBottomView)
        nameLabel.adjustsFontSizeToFitWidth = true
        configureTap()
    }

    private func configureTap() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(panelDidTap(_:)))
        gesture.delegate = self
        buttonTopView.isUserInteractionEnabled = true
        buttonTopView.addGestureRecognizer(gesture)

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        longPressGesture.delegate = self
        longPressGesture.minimumPressDuration = 0.1
        buttonTopView.addGestureRecognizer(longPressGesture)
    }

    @objc func panelDidTap(_ sender: UITapGestureRecognizer) {

        //制約を変更する前に一度layoutIfNeededを実行して未適用の表示を確実に更新しておくこと
        self.layoutIfNeeded()
        careButtonOn()

        UIView.animate(withDuration: CareButtonCollectionViewCell.animationDuration, delay: 0, options: [.allowUserInteraction], animations: {

            self.layoutIfNeeded()
            self.buttonTopView.backgroundColor = self.careButtonPanel.button?.colorType.darken(ratio: CareButtonCollectionViewCell.buttonOnColorRatio)

        }, completion: { _ in

            self.careButtonOff()

            UIView.animate(withDuration: CareButtonCollectionViewCell.animationDuration, animations: {
                self.layoutIfNeeded()
            })

        })

        careButtonAction()
    }

    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:

            self.layoutIfNeeded()
            careButtonOn()

            UIView.animate(withDuration: CareButtonCollectionViewCell.animationDuration, delay: 0, options: [.allowUserInteraction], animations: {
                self.layoutIfNeeded()
                self.buttonTopView.backgroundColor = self.careButtonPanel.button?.colorType.darken(ratio: CareButtonCollectionViewCell.buttonOnColorRatio)
            }, completion: nil)

        case .cancelled, .ended, .failed:

            self.layoutIfNeeded()
            careButtonOff()

            UIView.animate(withDuration: CareButtonCollectionViewCell.animationDuration, delay: 0, options: [.allowUserInteraction], animations: {
                self.layoutIfNeeded()
            }, completion: nil)

            careButtonAction()

        default:
            ()
        }
    }

    private func careButtonOff() {
        self.buttonTopView_Top_Constraint.constant = 0
        self.buttonTopView.backgroundColor = self.careButtonPanel.button?.colorType
    }

    private func careButtonOn() {
        self.buttonTopView_Top_Constraint.constant = 6
    }

    private func careButtonAction() {
        self.delegate?.careButtonCollectionViewCell(self)

        if place == .todayExtension {
            //TODO: TodayExtensionでアクションしたときの反応の実装
            self.descriptionLabel.text = "pushed!"
        }
    }

    func set(delegate: CareButtonCollectionViewCellDelegate) {
        self.delegate = delegate
    }

    func set(_ careButtonPanel: CareButtonPanel) {

        self.careButtonPanel = careButtonPanel

        switch careButtonPanel.operation {
        case .normal:
            guard let button = careButtonPanel.button else {
                logger.error("no button data")
                fatalError()
            }
            self.set(button)
        case .add:
            self.setAddMode()
        }
    }

    /* 名前ラベルに最終実行時間を表示する */
    func setWithLatestTime(_ careButtonPanel: CareButtonPanel) {
        set(careButtonPanel)

        //TODO: 最終実行時間を取得する
        CareButtonEventLogDummyData.getLatestLog(name: self.nameLabel.text!) { log in
            guard let log = log else {
                return
            }
            self.descriptionLabel.text = "⏰\(log.timeText())"

        }
    }

    private func set(_ careButton: CareButton) {
        self.nameLabel.text = careButton.name
        self.descriptionLabel.text = careButton.description ?? ""

        self.buttonTopView.backgroundColor = careButton.colorType
        self.buttonBottomView.backgroundColor = careButton.colorType.darken()
    }

    private func setAddMode() {
        setAddMode(buttonTopView)
        setAddMode(buttonBottomView)
        self.nameLabel.text = "＋"
        self.descriptionLabel.text = nil
    }

    private func setAddMode(_ buttonView: UIView) {
        buttonView.backgroundColor = UIColor.white
        buttonView.layer.borderWidth = 1
        buttonView.layer.borderColor = UIColor.lightGray.cgColor
    }

}

extension CareButtonCollectionViewCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //リコグナイザーの同時検知を許可する
        return false
    }
}
