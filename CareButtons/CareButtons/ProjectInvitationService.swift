//
//  ProjectInvitationService.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/04/10.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseDynamicLinks
import CoreImage
import UIKit

struct ProjectInvitationService {

    static func getInvitation() -> Single<Invitation> {

        return ProjectService.getDefaultProject()
            .flatMap { project in
                return readInvitation(projectId: project.id).map { (project: project, invitation: $0) }
            }
            .flatMap { result in
                if let invitation = result.invitation {
                    return Single.just(invitation)
                }

                return createInvitation(projectId: result.project.id)
            }
    }

    private static func readInvitation(projectId: String) -> Single<Invitation?> {

        let storage = FirestoreStorage()
        let docRef = storage.db
            .collectionInvitations()
            .whereField(InvitationData.Fields.projectId, isEqualTo: projectId)

        return Single.create { observer in

            docRef.getDocuments { (querySnapshot, error) in

                if let error = error {
                    observer(.error(error))
                    return
                }

                let parsed = querySnapshot?.documents.compactMap { doc in
                    return (doc.documentID, InvitationData.parse(dic: doc.data()))
                }

                guard let first = parsed?.first,
                    let data = first.1 else {

                        observer(.success(nil))
                        return
                }
                let invitation = Invitation(id: first.0, data: data)
                observer(.success(invitation))
            }
            return Disposables.create()
        }
    }

    private static func createInvitation(projectId: String) -> Single<Invitation> {
        let invitationKey = UUID().uuidString

        return createDynamicLink(key: invitationKey)
            .flatMap { (url: URL) in
                return createInvitationEntity(projectId: projectId, url: url, invitationKey: invitationKey)
        }
    }

    private static func createInvitationEntity(projectId: String, url: URL, invitationKey: String) -> Single<Invitation> {

        let storage = FirestoreStorage()
        let docRef = storage.db
            .collectionInvitations().document(invitationKey)

        let invitationData = InvitationData.create(projectId: projectId, link: url)

        return Single.create { observer in

            docRef.setData(invitationData.asDictionary(), completion: { (error) in
                if let error = error {
                    observer(.error(error))
                } else {
                    observer(.success(Invitation(id: docRef.documentID, data: invitationData)))
                }
            })

            return Disposables.create()
        }
    }

    private static func createDynamicLink(key: String) -> Single<URL> {

        //TODO: env
        let link = URL(string: "https://medium.com/@miso_soup3?\(Invitation.QueryKey)=\(key)")!
        let referralLink = DynamicLinkComponents(link: link, domain: "k9p93.app.goo.gl")

        referralLink.iOSParameters = DynamicLinkIOSParameters(bundleID: Bundle.main.bundleIdentifier!)
        referralLink.iOSParameters?.minimumAppVersion = "1.0"
        referralLink.iOSParameters?.appStoreID = "1370299580"

        let options = DynamicLinkComponentsOptions()
        options.pathLength = .unguessable
        referralLink.options = options

        return Single.create { observer in

            referralLink.shorten(completion: { (url, _, error) in
                if let error = error {
                    observer(.error(error))
                    return
                }
                guard let url = url else {
                    observer(.error(AppError.error("cannot create dynamic url")))
                    return
                }
                observer(.success(url))
            })

            return Disposables.create()
        }
    }

    static func generateQRCode(url: String) -> UIImage? {

        let data = url.data(using: .utf8)!
        let params: [String: Any] = [
            "inputMessage": data,
            "inputCorrectionLevel": "L"
        ]
        let filter = CIFilter(name: "CIQRCodeGenerator", withInputParameters: params)

        guard let image = filter?.outputImage else {
            return nil
        }
        guard let cgImage = CIContext().createCGImage(image, from: image.extent) else {
            return nil
        }

        let size = CGSize(width: 150, height: 150)
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.interpolationQuality = .none
        ctx?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resized
    }
}
