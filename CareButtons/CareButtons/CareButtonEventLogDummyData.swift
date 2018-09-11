//
//  CareButtonEventLog.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2017/12/29.
//  Copyright © 2017 Hiroka Yago. All rights reserved.
//

import Foundation
import UIKit
import KeychainAccess
import Firebase
import RxSwift

class CareButtonEventLogDummyData {

    static var data: [CareButtonEventLog] = {
       return [
        createDummy(name: "🍼", description: "ミルク", colorType: UIColor.CareButton.green),
        createDummy(name: "💩", description: "うんち", colorType: UIColor.CareButton.red)
        ]
    }()

    private static func createDummy(
        name: String,
        description: String?,
        colorType: UIColor) -> CareButtonEventLog {

        return CareButtonEventLog(baseCareButton: nil, time: Date(), name: name, description: description, colorType: colorType, amount: nil, amountUnitName: nil)
    }

    private static func load(projectId: String) -> Single<()> {
        return Single.create { observer in

            logger.debug("loading project: \(projectId)")

            let storage = FirestoreStorage()

            let docRef = storage.db
                .collection("projects")
                .document(projectId)
                .collection("logs")
                .order(by: "time", descending: true)
                .limit(to: 40)

            docRef.getDocuments { (querySnapshot, error) in
                if let error = error {
                    observer(.error(error))
                } else {

                    let data = querySnapshot!.documents.compactMap {
                        return CareButtonEventLogParser.parse(dic: $0.data())
                    }

                    CareButtonEventLogDummyData.data = data
                    logger.debug("success data loading")
                    observer(.success(()))
                }
            }
            return Disposables.create()
        }
    }

    static func load() -> Single<()> {
        return ProjectService.getDefaultProject()
            .flatMap { project in load(projectId: project.id) }
    }

    //指定したnameの最終実行ログを取得する
    static func getLatestLog(name: String, completion: @escaping (CareButtonEventLog?) -> Void) {

        let storage = FirestoreStorage()

        //TODO: get projects
        let projectId = "dummyproject"

        let docRef = storage.db
            .collectionProjects().document(projectId)
            .collection("logs")
            .whereField("name", isEqualTo: name)
            .order(by: "time", descending: true)
            .limit(to: 1)

        docRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                logger.error(error)
                fatalError()
            } else {
                let data = querySnapshot!.documents.compactMap {
                    return CareButtonEventLogParser.parse(dic: $0.data())
                }

                completion(data.first)

            }
        }
    }

    //日付ごとにグルーピングして返す
    static func getGrouping() -> [(key: Date, value: [CareButtonEventLog])] {

        var results: [Date: [CareButtonEventLog]] = [:]

        for log in self.data {

            let beginningOfDay = dateAtBeginningOfDay(date: log.time)
            let contains: Bool = results.contains { element in
                return element.key == beginningOfDay
            }

            if contains {
                results[beginningOfDay]?.append(log)
            } else {
                results[beginningOfDay] = [log]
            }
        }

        return  results.sorted(by: { $0.key > $1.key })
    }

    private static func dateAtBeginningOfDay(date: Date) -> Date {
        var calendar = Calendar.current
        let timezone = TimeZone.current
        calendar.timeZone = timezone
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = 0
        components.minute = 0
        components.second = 0

        guard let beginningOfDay = calendar.date(from: components) else {
            fatalError()
        }
        return beginningOfDay
    }
}

extension CareButtonEventLogDummyData {

    /// Today Extension より
    static func onPushOnToday(careButton: CareButton) {

        let log: CareButtonEventLog
        if careButton.hasAmount {
            // TODO: 直近の履歴から数量を取得する
            log = CareButtonEventLog(baseCareButton: careButton, amount: 99)
        } else {
            log = CareButtonEventLog(baseCareButton: careButton)
        }
        CareButtonEventLogDummyData.onPushCore(log: log)
    }

    static func onPush(careButton: CareButton) {
        let newLog = CareButtonEventLog(baseCareButton: careButton)
        CareButtonEventLogDummyData.onPushCore(log: newLog)
    }

    static func onPush(log: CareButtonEventLog) {
        CareButtonEventLogDummyData.onPushCore(log: log)
    }

    private static func onPushCore(log: CareButtonEventLog) {

        CareButtonEventLogDummyData.data.insert(log, at: 0)

        saveToFirestore(log: log)
        pushToSlack(log: log)
    }

    //Firestoreへ保存する
    private static func saveToFirestore(log: CareButtonEventLog) {

        //firestore
        let storage = FirestoreStorage()

        _ = ProjectService.getDefaultProject()
            .subscribe(onSuccess: { project in

                var ref: DocumentReference = storage.db
                    .collectionProjects().document(project.id)

                ref = ref.collection("logs").addDocument(data: log.asDictionary()) { error in
                    if let error = error {
                        logger.error(error)
                    } else {
                        logger.debug("success")
                    }
                }

            }, onError: { error in
                logger.error(error)
            })
    }

    private static func pushToSlack(log: CareButtonEventLog) {
        SlackAction.Action(log: log)
    }

}
