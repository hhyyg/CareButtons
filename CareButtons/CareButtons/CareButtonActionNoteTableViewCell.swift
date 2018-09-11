//
//  CareButtonActionImageTableViewCell.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/01/03.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import UIKit

class CareButtonActionNoteTableViewCell: UITableViewCell {

    static let cellIdentifier = "CareButtonActionNoteTableViewCell"

    @IBOutlet weak var textView: UITextView!

    private weak var delegate: CareButtonActionNoteTableViewCellProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()

        logger.debug("awake From Nib")

        selectionStyle = .none
        configureTextView()
    }

    private func configureTextView() {
        textView.delegate = self
        textViewToPlaceHolerMode()
    }

    private func textViewToPlaceHolerMode() {
        textView.text = "メモを入力..."
        textView.textColor = TextColor.placeHolder
    }

    private func textViewToInputMode() {
        textView.text = nil
        textView.textColor = TextColor.input
    }

    func set(delegate: CareButtonActionNoteTableViewCellProtocol) {
        self.delegate = delegate
    }
}

extension CareButtonActionNoteTableViewCell {
    struct TextColor {
        static let input = UIColor.black
        static let placeHolder = UIColor.lightGray
    }
}

extension CareButtonActionNoteTableViewCell: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {

        //place holder
        if textView.textColor == TextColor.placeHolder {
            textViewToInputMode()
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {

        //place holder
        if textView.text.isEmpty {
            textViewToPlaceHolerMode()
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        delegate?.noteTextView(self, didChange: textView.text)
    }
}

protocol CareButtonActionNoteTableViewCellProtocol: class {
    func noteTextView(_ viewCell: UITableViewCell, didChange note: String)
}
