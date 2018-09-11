//
//  AppDelegate.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2017/12/27.
//  Copyright © 2017 Hiroka Yago. All rights reserved.
//

import UIKit
import Firebase
import KeychainAccess
import TwitterKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let disposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        //TODO:debug
        //iterateKeychainItems(log: true, delete: true)

        ApplicationBuilder.setup(target: .app).subscribe(onSuccess: { () in
            ()
        }, onError: { error in
            logger.error(error)
        }).disposed(by: disposeBag)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RootViewController()
        window?.makeKeyAndVisible()

        return true
    }

    //カスタムURLスキーム
    //アプリをインストールした後はじめてのユニバーサルリンク
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
/*
        if let dynamicLink = DynamicLinks.dynamicLinks()?.dynamicLink(fromCustomSchemeURL: url) {
            // Handle the deep link. For example, show the deep-linked content or
            // apply a promotional offer to the user's account.

            return self.handleDynamicLink(dynamicLink)
        }
*/
        return TWTRTwitter.sharedInstance().application(app, open: url, options: options)

 }

    //既にアプリがインストールされている場合のユニバーサルリンク
    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([Any]?) -> Void) -> Bool {

        logger.debug(userActivity.webpageURL)
/*
        guard let dynamicLinks = DynamicLinks.dynamicLinks() else {
            return false
        }

        let handled = dynamicLinks.handleUniversalLink(userActivity.webpageURL!) { (dynamicLink, error) in
            if let error = error {
                logger.error(error)
            }

            guard let dynamicLink = dynamicLink else {
                logger.debug("dynamicLink is nil")
                return
            }

            _ = self.handleDynamicLink(dynamicLink)
        }
        if !handled {
            // Handle incoming URL with other methods as necessary
            // ...
        }

        return handled
 */
        return false
 }

    private func handleDynamicLink(_ dynamicLink: DynamicLink) -> Bool {

        //特定の受信者を対象としたリンクを受信する場合、ユーザー固有のロジックを実行する前に、ダイナミック リンクの一致信頼度が strong であることを確認してください。
        if dynamicLink.matchType != .unique {
            return false
        }
        guard let deepLink = dynamicLink.url else {
            return false
        }
        let queryItems = URLComponents(url: deepLink, resolvingAgainstBaseURL: true)?.queryItems
        guard let key = queryItems?.filter({ $0.name == Invitation.QueryKey }).first?.value else {
            return false
        }

        logger.debug("key is \(key)")
        //TODO: keyを渡す
        rootViewController.showLoginProject(key: key)
        return true
    }
}

extension AppDelegate {

    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    var rootViewController: RootViewController {
        guard let root = window!.rootViewController else {
            fatalError()
        }

        guard let rootViewController = root as? RootViewController else {
            fatalError()
        }

        return rootViewController
    }

}

//TODO: debug
func iterateKeychainItems(log: Bool, delete: Bool) {
    let secItemClasses = [
        kSecClassGenericPassword,
        kSecClassInternetPassword,
        kSecClassCertificate,
        kSecClassKey,
        kSecClassIdentity
    ]

    if log {
        for secItemClass in secItemClasses {
            let query: [String: Any] = [
                kSecReturnAttributes as String: kCFBooleanTrue,
                kSecMatchLimit as String: kSecMatchLimitAll,
                kSecClass as String: secItemClass
            ]

            var result: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &result)
            if status == noErr {
                print(result as Any)
            }
        }
        print("AppUsageMetadata.iterateKeychainItems ended.")
    }

    if delete {
        for secItemClass in secItemClasses {
            let dictionary = [kSecClass as String: secItemClass]
            SecItemDelete(dictionary as CFDictionary)
        }
    }
}
