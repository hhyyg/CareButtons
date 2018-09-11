//
//  UserDefaultsService.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/03/04.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import Foundation

class UserDefaultsService {
    enum Key: String {
        case appUserDefaults
    }
}

struct AppUserDefaults: Codable {
    static private let decoder = JSONDecoder()
    static private let encoder = JSONEncoder()
    static private let container = UserDefaults(suiteName: "group.com.miso.CareButtons")!

    //CareButtonの各ボタンの初期値
    var careButtonAmountInitialValue: [String: Decimal] = [:]
    //Project
    var project: Project?

    static func get() -> AppUserDefaults {

        guard let data = AppUserDefaults.container.data(forKey: UserDefaultsService.Key.appUserDefaults.rawValue) else {
            return AppUserDefaults.init()
        }

        do {
            let defaults = try decoder.decode(AppUserDefaults.self, from: data)
            return defaults
        } catch {
            return AppUserDefaults()
        }
    }

    func save() {

        let data = try! AppUserDefaults.encoder.encode(self)
        AppUserDefaults.container.set(data, forKey: UserDefaultsService.Key.appUserDefaults.rawValue)
    }

    static func clear() {
        AppUserDefaults.container.removeObject(forKey: UserDefaultsService.Key.appUserDefaults.rawValue)
    }
}
