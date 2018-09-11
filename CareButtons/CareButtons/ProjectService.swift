//
//  ProjectService.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/04/04.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import Foundation
import RxSwift
import Firebase
import KeychainAccess
import FirebaseDynamicLinks

struct ProjectService {

    ///ユーザーのプロジェクトを取得する
    private static func getFirstProject() -> Single<Project?> {

        guard let user = Auth.auth().currentUser else {
            return Single.error(AppError.error("not found user"))
        }

        let storage = FirestoreStorage()
        let projectsRef = storage.db
            .collectionUsers().document(user.uid)
            .collectionSelectProjects()

        return Single.create { observer in

            projectsRef.getDocuments { (querySnapshot, error) in
                if let error = error {
                    observer(.error(error))
                } else {
                    let parsed = querySnapshot?.documents.compactMap { doc in
                        return (doc.documentID, ProjectData.parse(dic: doc.data()))
                    }
                    guard let first = parsed?.first,
                        let data = first.1 else {

                        observer(.success(nil))
                        return
                    }
                    let project = Project(id: first.0, data: data)
                    observer(.success(project))
                }
            }
            return Disposables.create()
        }
    }

    ///ユーザーのプロジェクトを作成する
    private static func createFirstProject() -> Single<Project> {

        guard let user = Auth.auth().currentUser else {
            return Single.error(AppError.error("not found user"))
        }

        return Single.create { observer in

            let newProjectData = ProjectData.createNewProject(ownerUserId: user.uid)

            let storage = FirestoreStorage()
            let batch = storage.db.batch()

            let rootProjectDocument = storage.db
                .collectionProjects()
                .document()

            let usersProjectDocument = storage.db
                .collectionUsers().document(user.uid)
                .collectionSelectProjects().document(rootProjectDocument.documentID)

            batch.setData(newProjectData.asDictionary(), forDocument: usersProjectDocument)
            batch.setData(newProjectData.asDictionary(), forDocument: rootProjectDocument)

            batch.commit { error in
                if let error = error {
                    observer(.error(error))
                } else {
                    let newProject = Project(id: rootProjectDocument.documentID, data: newProjectData)
                    observer(.success(newProject))
                }
            }
            return Disposables.create()
        }

    }

    //Userの利用するProjectを取得します
    static func getDefaultProject() -> Single<Project> {

        var userDefaults = AppUserDefaults.get()
        if let project = userDefaults.project {
            return Single.just(project)
        }

        return getFirstProject()
            .flatMap { project in
                if let project = project {
                    return Single.just(project)
                }
                return createFirstProject()
            }
            .do(onSuccess: { project in
                userDefaults.project = project
                userDefaults.save()
            })
    }

    //共有中のプロジェクトメンバーを取得します
    static func getSharedUser() -> Single<SharedUser?> {
        return Single.just(nil)
    }

}
