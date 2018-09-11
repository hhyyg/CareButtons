//
//  SettingsTableViewController.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/03/30.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import UIKit
import TwitterKit
import FirebaseAuth
import RxSwift

class SettingsTableViewController: UITableViewController {

    enum CellType: String, EnumCollection {
        case loginTwitter = "logginTwitter"
        case logoutTwitter = "logoutTwitter"
        case invite = "invite"

    }

    var cells: [CellType] = []
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .groupTableViewBackground
        tableView.tableFooterView = UIView(frame: CGRect.zero)

        //セルの設定
        setupCells()

        for cellType in CellType.allValues {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellType.rawValue)
        }
    }

    private func setupCells() {

        cells = []
        if UserService.isTwitterLoggedInUser() {
            cells.append(CellType.logoutTwitter)
        } else {
            cells.append(CellType.loginTwitter)
        }
        cells.append(CellType.invite)

    }

    private func refresh() {
        DispatchQueue.main.async {

            AppDelegate.shared.rootViewController.refreshUser()

            /*
            self.setupCells()
            //TODO:全て更新？
            self.tableView.reloadRows(at: self.tableView.indexPathsForVisibleRows!, with: UITableViewRowAnimation.fade)
             */
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellType = cells[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath)

        cell.textLabel?.text = getText(type: cellType)
        cell.imageView?.image = getIcon(type: cellType)

        if cellType == .invite && !UserService.isTwitterLoggedInUser() {
            cell.accessoryType = .none
            cell.textLabel?.isEnabled = false
            cell.imageView?.alpha = 0.5
            cell.isUserInteractionEnabled = false
            cell.backgroundColor = UIColor.lightGray

        } else {
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.isEnabled = true
            cell.imageView?.alpha = 1
            cell.isUserInteractionEnabled = true
            cell.backgroundColor = UIColor.white
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cellType = cells[indexPath.row]
        if cellType == .invite && !UserService.isTwitterLoggedInUser() {
            return nil
        }

        return indexPath
    }

    private func getIcon(type: CellType) -> UIImage {
        switch type {
        case .loginTwitter, .logoutTwitter:
            return #imageLiteral(resourceName: "twitter")
        case .invite:
            return #imageLiteral(resourceName: "member")
        }
    }

    //TODO:
    /*
     Twitterでログインする：
        すでにTWitterユーザーが登録されている：どちらのデータにするか
        Twitterユーザーが登録されていない：リンクする
     */

    private func getText(type: CellType) -> String {
        switch type {
        case .loginTwitter:
            return "Twitter でログイン"
        case .logoutTwitter:
            guard let id = UserService.getTwitterUserName() else {
                logger.error("cannnot get twitterId")
                return "ログアウト"
            }
            return "ログアウト @\(id)"
        case .invite:
            return "データの共有"
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cellType = cells[indexPath.row]

        switch cellType {
        case .loginTwitter:
                twitterLogin()
        case .logoutTwitter:
                twitterLogout()
        case .invite:
                invite()
        }

    }

    private func invite() {

        let inviteVC = ControllerFactory.build(type: .inviteTableViewController)
        self.navigationController?.pushViewController(inviteVC, animated: true)

    }

    private func twitterLogout() {

        Authenticator.signOut()
            .flatMap { _ in return Authenticator.signInAnonymously() }
            .flatMap { _ in return ApplicationBuilder.dataLoad() }
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { _ in
                self.refresh()
            }, onError: { error in
            logger.error(error)
        }).disposed(by: disposeBag)
    }

    private func twitterLogin() {

        Authenticator.signInTwitter(with: self)
            .flatMap { _ in return ApplicationBuilder.dataLoad() }
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { _ in
                self.refresh()
            }, onError: { error in
            logger.error(error)
        }).disposed(by: disposeBag)

    }

}
