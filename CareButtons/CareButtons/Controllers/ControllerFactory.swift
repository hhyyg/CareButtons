//
//  ControllerFactory.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/04/06.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import Foundation
import UIKit

class ControllerFactory {

    enum ControllerType {
        case mainController
        case inviteTableViewController
        case loginViewController
    }

    static func build(type: ControllerType) -> UIViewController {
        switch type {
        case .mainController:
            return instantiateInitialViewController(name: "MainController") as! MainController
        case .inviteTableViewController:
            return instantiateInitialViewController(name: "InviteTableViewController") as! InviteTableTableViewController
        case .loginViewController:
            return instantiateInitialViewController(name: "LoginViewController") as! LoginViewController
        }
    }

    private static func instantiateInitialViewController(name: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
}
