//
//  Invitation.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/04/10.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import Foundation

struct Invitation: Codable {

    //dynamic linkにいれるクエリ文字列のキー
    static let QueryKey = "key"

    let id: String
    let data: InvitationData

    var key: String { return self.id }
    var link: URL { return self.data.link }
}

struct InvitationData: Codable {

    struct Fields {
        static let createdAt = "createdAt"
        static let projectId = "projectId"
        static let link = "link"
    }

    let createdAt: Date
    let projectId: String
    let link: URL

    static func create(projectId: String, link: URL) -> InvitationData {
        return InvitationData(createdAt: Date(), projectId: projectId, link: link)
    }
}

extension InvitationData {
    func asDictionary() -> [String: Any] {
        return [
            InvitationData.Fields.createdAt: createdAt,
            InvitationData.Fields.projectId: projectId,
            InvitationData.Fields.link: link.absoluteString
        ]
    }

    static func parse(dic: [String: Any]) -> InvitationData? {

        guard let createdAt = dic[InvitationData.Fields.createdAt] as? Date else {
            return nil
        }

        guard let projectId = dic[InvitationData.Fields.projectId] as? String else {
            return nil
        }

        guard let linkValue = dic[InvitationData.Fields.link] as? String else {
            return nil
        }

        guard let link = URL(string: linkValue) else {
            return nil
        }

        return InvitationData(createdAt: createdAt, projectId: projectId, link: link)
    }
}
