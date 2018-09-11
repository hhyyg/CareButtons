//
//  DbTree.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/04/09.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import Foundation
import Firebase

extension Firestore {

    func collectionUsers() -> CollectionReference {
        return self.collection("users")
    }

    func collectionProjects() -> CollectionReference {
        return self.collection("projects")
    }

    func collectionInvitations() -> CollectionReference {
        return self.collection("invitations")
    }

}

extension DocumentReference {

    func collectionSelectProjects() -> CollectionReference {
        return self.collection("selectProjects")
    }

}
