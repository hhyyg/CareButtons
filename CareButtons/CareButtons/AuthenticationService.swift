//
//  AuthenticationService.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/04/02.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxSwift
import TwitterKit

struct Authenticator {

    enum AuthError: Error {
        case canNotSignIn
    }

    static func signInAnonymously() -> Single<User> {

        return Single.create { observer in
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    observer(.error(error))
                    return
                }

                guard let result = result else {
                    observer(.error(AuthError.canNotSignIn))
                    return
                }

                let user = result.user

                logger.debug("success signInAnonymously userId:\(user.uid)")
                observer(.success(user))
            }
            return Disposables.create()
        }
    }

    //ユーザー情報をすべて削除
    private static func clearUserData() {
        AppUserDefaults.clear()
    }

    static func signOut() -> Single<()> {

        clearUserData()

        return Single<()>.create { observer in

            do {
                try Auth.auth().signOut()
            } catch let error {
                observer(.error(error))
            }

            observer(.success(()))
            return Disposables.create()
        }
    }

    static func signInProject(with vc: UIViewController) -> Single<()> {
        return signInTwitter(with: vc)
    }

    static func signInTwitter(with vc: UIViewController) -> Single<()> {

        //条件：TwitterUserがFirebaseに存在する：（現在の匿名ユーザーを破棄し）、そのユーザーとみる
        //  Link処理してエラーになったらこの条件と判断する
        //条件：TwitterUserがFirebaseに存在しない：リンクして匿名ユーザーからTwitterユーザーになる

        guard let currentUser = Auth.auth().currentUser else {
            return Single.error(AppError.error("invalid method"))
        }

        return Single<()>.create { observer in

            TWTRTwitter.sharedInstance().logIn(with: vc) { (session, error) in

                guard let session = session else {
                    if let error = error {
                        observer(.error(error))
                    }
                    observer(.error(AppError.error("no session")))
                    return
                }

                logger.debug("Twitter signed in as \(session.userName) \(session.userID) ")
                let credential = TwitterAuthProvider.credential(withToken: session.authToken, secret: session.authTokenSecret)

                currentUser.link(with: credential) { (user, error) in

                    guard let error = error else {
                        //リンクが成功し、匿名新規ログインである

                        //TODO: Twitter情報の保存
                        KeychainService.set(forKey: .loggedTwitterId, value: session.userName)
                        observer(.success(()))
                        return
                    }
                    //リンクがエラーとなる＝再ログインとみなす

                    logger.debug(error.localizedDescription)

                    //TODO: データが消えますが良いですか？
                    clearUserData()
                    Auth.auth().signIn(with: credential, completion: { (user, error) in

                        if let error = error {
                            observer(.error(error))
                            return
                        }
                        if user == nil {
                            observer(.error(AppError.error("cannot signIn twitter")))
                            return
                        }

                        //success login
                        //TODO: Twitter情報の保存
                        KeychainService.set(forKey: .loggedTwitterId, value: session.userName)

                        observer(.success(()))
                    })

                }

            }

            return Disposables.create()
        }
    }

}
