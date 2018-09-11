//
//  LoginViewController.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/04/16.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import UIKit
import RxSwift
import Firebase

class LoginViewController: UIViewController {

    private let disposeBag = DisposeBag()

    var invitationKey: String!
    lazy var function = Functions.functions()

    override func viewDidLoad() {
        super.viewDidLoad()

        loginTwitter()
    }

    @IBAction func tappedCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    private func loginTwitter() {

        //TODO:
        // key がある前提
        //自分が匿名ユーザーである：Twitterでログインする　次へ
        //自分がTwitterユーザーである：次へ
        let isTwitterUser = UserService.isTwitterLoggedInUser()
        let twitterId = UserService.getTwitterUserName()
        let requiredLoginTwitter = (twitterId == nil) || !isTwitterUser

        let data = ["a": twitterId, "b": invitationKey]
        function.httpsCallable("alal").call(data) { (result, error) in
            if let error = error {

                return
            }

            if let projectId = (result?.data as? [String: Any])?["projectId"] as? String {

                return
            }
        }

        //TwitterId, Key を投げる
        // ProjectId 取得　正常：設定、リロード
        // ProjectId 取得　既に参加or自分：そのまま閉じる
        // Error エラー表示、閉じる

        Authenticator.signInProject(with: self).subscribe(onSuccess: { (_) in

            logger.debug("logged")

        }, onError: { (error) in
            logger.error(error)
        }).disposed(by: disposeBag)
    }

}
