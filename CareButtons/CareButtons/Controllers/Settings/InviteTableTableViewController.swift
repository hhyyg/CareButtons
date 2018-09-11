//
//  InviteTableTableViewController.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/04/09.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import UIKit
import RxSwift
import NativePopup

class InviteTableTableViewController: UITableViewController {

    enum CellType: String {
        case sharedUser
        case noExistSharedUser
        case inviteCode
    }

    var identities: [CellType: String] = [:]
    var cells: [CellType] = []
    var sharedUser: SharedUser?
    var invitation: Invitation?
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .groupTableViewBackground
        tableView.tableFooterView = UIView(frame: CGRect.zero)

        setupIdentity()
        registCells()
    }

    override func viewWillAppear(_ animated: Bool) {

        ProjectService.getSharedUser()
            .do(onSuccess: { sharedUser in
                self.sharedUser = sharedUser
            })
            .flatMap { _ in
                return ProjectInvitationService.getInvitation()
            }
            .do(onSuccess: { invitation in
                self.invitation = invitation
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { (_) in
                self.updateCells()
            }, onError: { error in
            logger.error(error)
        }).disposed(by: disposeBag)
    }

    private func updateCells() {

        cells = []
        if self.sharedUser != nil {
            cells.append(.sharedUser)
        } else {
            cells.append(.inviteCode)
        }
        self.tableView.reloadRows(at: self.tableView.indexPathsForVisibleRows!, with: UITableViewRowAnimation.fade)
    }

    private func setupIdentity() {
        identities = [:]
        identities[.sharedUser] = SharedUserTableViewCell.cellIdentifier
        identities[.inviteCode] = InviteCodeTableViewCell.cellIdentifier
        identities[.noExistSharedUser] = NoExistSharedUserTableViewCell.cellIdentifier
    }

    private func registCells() {
        for identitiy in identities {
            let nib = UINib(nibName: identitiy.value, bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: identitiy.value)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if cells.count == 0 {
            return UITableViewCell(style: .default, reuseIdentifier: "dummy")
        }

        let cellType = cells[indexPath.section]

        let cell = tableView.dequeueReusableCell(withIdentifier: identities[cellType]!, for: indexPath)

        if let sharedUserCell = cell as? SharedUserTableViewCell {

            let user = SharedUser(twitterId: "miso_soup3", sharedAt: Date())
            sharedUserCell.set(sharedUser: user)
            return sharedUserCell
        }

        if let inviteCell = cell as? InviteCodeTableViewCell,
            let invitation = self.invitation {

            inviteCell.linkLabel.text = invitation.link.absoluteString
            inviteCell.qrCodeImage.image = ProjectInvitationService.generateQRCode(url: invitation.link.absoluteString)
            return inviteCell
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = cells[indexPath.section]
        if cellType == .inviteCode {
            selectedInviteCell()
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func selectedInviteCell() {
        guard let invitation = invitation else {
            logger.error("invitation is nil")
            return
        }
        let pastedBoard = UIPasteboard.general
        pastedBoard.string = invitation.link.absoluteString

        NativePopup.show(image: Preset.Feedback.done, title: "Copied!", message: "共有URLをコピーしました")
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if let cellType = cells.first,
            cellType == .inviteCode {
            return 320
        }

        return 85
    }

}
