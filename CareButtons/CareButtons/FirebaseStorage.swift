//
//  FirebaseStorage.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/03/05.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import Foundation
import Firebase

class FirestoreStorage {

    let db: Firestore!

    init() {
        db = Firestore.firestore()
    }

    func addTest() {
        var ref: DocumentReference? = nil

        ref = db.collection("testData").addDocument(data: [
            "first": "Ada",
            "last": "Lovelace",
            "born": 1815
        ]) { error in
            if let error = error {
                logger.error(error)
            } else {
                logger.debug("success: \(ref!.documentID)")
            }
        }

    }

}
