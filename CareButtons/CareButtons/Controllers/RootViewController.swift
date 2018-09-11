//
//  RootViewController.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2017/12/27.
//  Copyright © 2017 Hiroka Yago. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    private var current: UIViewController = SplashViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildViewController(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParentViewController: self)
    }

    func switchToMainScreen() {

        let nextVC = ControllerFactory.build(type: .mainController)

        addChildViewController(nextVC)
        nextVC.view.frame = view.bounds
        view.addSubview(nextVC.view)
        nextVC.didMove(toParentViewController: self)

        current.willMove(toParentViewController: nil)
        current.view.removeFromSuperview()
        current.removeFromParentViewController()

        current = nextVC
    }

    //ログインユーザーが変わったときのために、画面をリフレッシュします。
    func refreshUser() {

        let nextVC = ControllerFactory.build(type: .mainController)
        animateDismissTransition(to: nextVC)

    }

    //プロジェクト参加画面を表示する
    func showLoginProject(key: String) {
        //TODO: keyを渡す
        let vc = ControllerFactory.build(type: .loginViewController) as! LoginViewController
        vc.invitationKey = key
        self.present(vc, animated: true, completion: nil)

    }

    private func animateDismissTransition(to new: UIViewController, completion: (() -> Void)? = nil) {

        let initialFrame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        current.willMove(toParentViewController: nil)
        addChildViewController(new)
        new.view.frame = initialFrame

        transition(from: current, to: new, duration: 0.3, options: [.transitionCrossDissolve], animations: {
            new.view.frame = self.view.bounds
        }, completion: { _ in
            self.current.removeFromParentViewController()
            new.didMove(toParentViewController: self)
            self.current = new
            completion?()
        })
    }

}
