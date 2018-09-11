//
//  UserService.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/04/02.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import Foundation
import FirebaseAuth

class UserService {

    //Twitterでログイン済みかどうか
    static func isTwitterLoggedInUser() -> Bool {
        guard let user = Auth.auth().currentUser else {
            return false
        }

        //TODO:かつ、KeychainからTwitterIdが取得できる
        return user.providerData.contains { $0.providerID == "twitter.com" }
    }

    static func getTwitterUserName() -> String? {
        if Auth.auth().currentUser == nil {
            return nil
        }
        return KeychainService.get(forKey: .loggedTwitterId)
    }

}
