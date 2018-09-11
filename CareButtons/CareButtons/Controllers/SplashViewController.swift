//
//  SplashViewController.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2017/12/27.
//  Copyright © 2017 Hiroka Yago. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.gray
        switchToMainScreen()
    }

    private func switchToMainScreen() {
        AppDelegate.shared.rootViewController.switchToMainScreen()
    }
}
