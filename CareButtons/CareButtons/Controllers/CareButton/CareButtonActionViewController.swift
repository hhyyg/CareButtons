//
//  CareButtonActionViewController.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2017/12/31.
//  Copyright © 2017 Hiroka Yago. All rights reserved.
//

import UIKit
import NativePopup

class CareButtonActionViewController: UIViewController, UINavigationControllerDelegate {

    enum Mode {
        case create
        case edit
    }

    var mode: Mode = .create

    private var careButton: CareButton!
    //入力された値
    private var selectedDate: Date?
    private var amount: Decimal?
    private var note: String?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var careButtonView: CareButtonView!
    @IBOutlet weak var descriptionLabel: UILabel!

    private var cells = [
        CareButtonActionTimeTableViewCell.cellIdentifier
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCustomCell()
        setupRightBarButton()
        setupLeftBatButton()

        setCareButtonValue()
    }

    override func viewWillAppear(_ animated: Bool) {
        //空の行、セルの境界線を表示しない
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    private func setupRightBarButton() {
        let barButton: UIBarButtonItem
        switch mode {
        case .create:
            barButton = UIBarButtonItem(title: "Push!", style: .done, target: self, action: #selector(pushButtonDidTap))
        case .edit:
            barButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveButtonDidTap))
        }

        self.navigationItem.setRightBarButton(barButton, animated: false)
    }

    private func setupLeftBatButton() {
        let barButton: UIBarButtonItem
        switch mode {
        case .create:
            barButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonDidTap))
            self.navigationItem.setLeftBarButton(barButton, animated: false)
        case .edit:
            ()
        }
    }

    private func setupCustomCell() {

        if careButton.hasAmount {
            cells.append(CareButtonActionQuantityTableViewCell.cellIdentifier)
        }

        if careButton.hasNote {
            cells.append(CareButtonActionNoteTableViewCell.cellIdentifier)
        }

        for cellName in cells {
            let nib = UINib(nibName: cellName, bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: cellName)
        }

        //TODO: Nibの登録と実際の行表示を分ける
        // 時間
        let nib = UINib(nibName: CareButtonActionSelectTimeTableViewCell.cellIdentifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: CareButtonActionSelectTimeTableViewCell.cellIdentifier)
    }

    private func setCareButtonValue() {
        descriptionLabel.text = careButton.description
        self.careButtonView.set(careButton: careButton)
    }

    func set(_ careButtonPanel: CareButtonPanel) {
        assert(mode == .create)
        //ボタンをタップしたとき
        guard let careButton = careButtonPanel.button else {
            fatalError("careButton type should be Normal")
        }

        self.careButton = careButton
    }

    func set(_ careButton: CareButton) {
        assert(mode == .edit)
        //編集からきたとき
        self.careButton = careButton
    }

    @objc func cancelButtonDidTap(_ sender: UIBarButtonItem) {

        switch mode {
        case .create:
            self.navigationController?.dismiss(animated: true, completion: nil)
        case .edit:
            self.navigationController?.popViewController(animated: true)
        }

    }

    @objc func pushButtonDidTap(_ sender: UIBarButtonItem) {
        assert(mode == .create)

        var newLog = CareButtonEventLog(baseCareButton: careButton)

        if let changedDate = self.selectedDate {
            newLog.time = changedDate
        }

        if careButton.hasAmount {
            assert(self.amount != nil)
            assert(careButton.amountUnitName != nil)

            newLog.amount = self.amount
            newLog.amountUnitName = careButton.amountUnitName
            careButton.setDefaultAmount(amount: self.amount!)
        }

        if careButton.hasNote {
            newLog.note = self.note
        }

        CareButtonEventLogDummyData.onPush(log: newLog)
        NativePopup.show(image: UIImage(named: "nice")!, title: "\(careButton.name)", message: nil)

        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    @objc func saveButtonDidTap(_ sender: UIBarButtonItem) {
        assert(mode == .edit)
        self.navigationController?.popViewController(animated: true)
    }
}

extension CareButtonActionViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellName = cells[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath)

        if let selectTimeCell = cell as? CareButtonActionSelectTimeTableViewCell {
            selectTimeCell.set(delegate: self)

            return cell
        }

        if let amountCell = cell as? CareButtonActionQuantityTableViewCell {
            assert(careButton.amountUnitName != nil)

            self.amount = careButton.getDefaultAmount()
            amountCell.set(delegate: self)
            amountCell.set(amount: self.amount!, amountUnitName: careButton.amountUnitName!)
            return cell
        }

        if let noteCell = cell as? CareButtonActionNoteTableViewCell {
            noteCell.set(delegate: self)
            return cell
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cellName = cells[indexPath.row]
        if cellName == CareButtonActionTimeTableViewCell.cellIdentifier {
            viewSelectTimeView()
        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellName = cells[indexPath.row]

        if cellName == CareButtonActionNoteTableViewCell.cellIdentifier {
            return 120
        }

        if cellName == CareButtonActionSelectTimeTableViewCell.cellIdentifier {
            return 160
        }

        return 60
    }

}

extension CareButtonActionViewController {

    /// Time cell tap
    func viewSelectTimeView() {

        guard !cells.contains(CareButtonActionSelectTimeTableViewCell.cellIdentifier) else {
            return
        }

        //view select time view
        tableView.beginUpdates()
        cells.insert(CareButtonActionSelectTimeTableViewCell.cellIdentifier, at: 1)
        let indexPath = IndexPath(row: 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()

    }

}

extension CareButtonActionViewController: CareButtonActionSelectTimeTableViewCellProtocol {
    func selectTimeDatePicker(_ viewCell: CareButtonActionSelectTimeTableViewCell, valueChanged date: Date) {

        selectedDate = date
    }
}

extension CareButtonActionViewController: CareButtonActionQuantityTableViewCellProtocol {
    func quantity(_ viewCell: CareButtonActionQuantityTableViewCell, valueChanged value: Decimal) {
        amount = value
    }
}

extension CareButtonActionViewController: CareButtonActionNoteTableViewCellProtocol {
    func noteTextView(_ viewCell: UITableViewCell, didChange note: String) {
        self.note = note
    }
}
