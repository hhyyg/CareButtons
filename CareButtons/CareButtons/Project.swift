//
//  Project.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/04/04.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import Foundation

struct Project: Codable {
    let id: String
    let data: ProjectData
}

struct ProjectData: Codable {
    let createdAt: Date
    let ownerUserId: String

    static func createNewProject(ownerUserId: String) -> ProjectData {
        return ProjectData(createdAt: Date(), ownerUserId: ownerUserId)
    }
}

extension ProjectData {
    func asDictionary() -> [String: Any] {
        return [
            "createdAt": createdAt,
            "ownerUserId": ownerUserId
        ]
    }

    static func parse(dic: [String: Any]) -> ProjectData? {

        guard let createdAt = dic["createdAt"] as? Date else {
            return nil
        }

        guard let ownerUserId = dic["ownerUserId"] as? String else {
            return nil
        }

        return ProjectData(createdAt: createdAt, ownerUserId: ownerUserId)
    }
}
