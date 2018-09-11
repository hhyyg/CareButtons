//
//  ApplicationBuilder.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/03/09.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import Foundation
import KeychainAccess
import Firebase
import TwitterKit
import RxSwift

class ApplicationBuilder {

    enum Target {
        case app
        case appExtension
    }

    private static let appKeychain = Keychain(service: "firebase_auth_1:343736235530:ios:***")
    private static let extensionKeychain = Keychain(service: "firebase_auth_1:343736235530:ios:***")
    private static let userKeychainKey = "firebase_auth_1___FIRAPP_DEFAULT_firebase_user"

    private static var target: Target = .app

    static func setup(target: Target) -> Single<()> {
        ApplicationBuilder.target = target

        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        if target == .app {
            initTwitter()
        }

        if target == .appExtension {
            saveLoggedUserInfoToKeychain()
        }

        if let user = Auth.auth().currentUser {

            logger.debug("Auth currentUser: \(user.uid)")
            logger.debug("isAnonymous: \(user.isAnonymous)")
            logger.debug("providerId: \(user.providerID)")

            user.getIDToken { (token, _) in
                if let token = token {
                    logger.debug(token)
                }
            }

            for info in user.providerData {
                logger.debug("uid: \(info.uid)")
                logger.debug("UserInfo.providerId: \(info.providerID)")
                logger.debug("UserInfo.displayName: \(info.displayName ?? "")")
            }

            return dataLoad()
        }

        if target == .appExtension {
            //TODO: Extensionを起動したとき、アプリ側で認証が完了していないときどうするか

            return Single.create { observer in
                observer(.error(AppError.error("not implementation")))
                return Disposables.create()
            }
        }

        return Authenticator.signInAnonymously()
            .flatMap { _ in return dataLoad() }

    }

    static func dataLoad() -> Single<()> {
        return CareButtonEventLogDummyData.load()
    }

    private static func initTwitter() {
        TWTRTwitter.sharedInstance().start(withConsumerKey: "", consumerSecret: "")
    }

    //Appの認証情報をExtension側に同期
    private static func saveLoggedUserInfoToKeychain() {
        //get data
        guard let data = (try? appKeychain.getData(userKeychainKey)) as? Data else {
            try! extensionKeychain.remove(userKeychainKey)
            return
        }

        //save
        try? extensionKeychain.set(data, key: userKeychainKey)

        logger.debug("saved in EXTENSION KEYCHAIN")
    }

}
