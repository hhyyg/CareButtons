//
//  KeychainAccess.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/01/31.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import Foundation
import KeychainAccess

class KeychainService {
    enum Key: String {
        case loggedTwitterId
    }

    private static var keychain = Keychain(
        service: "com.miso.CareButtons",
        accessGroup: Bundle.main.object(forInfoDictionaryKey: "AppIdentifierPrefix") as! String + "com.miso.CareButtons").accessibility(.always)

    static func get(forKey key: Key) -> String? {
        return keychain[key.rawValue]
    }

    static func set(forKey key: Key, value: String) {
        keychain[key.rawValue] = value
    }

    static func remove(forKey key: Key) {
        try! keychain.remove(key.rawValue)
    }

}
