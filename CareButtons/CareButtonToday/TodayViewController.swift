//
//  TodayViewController.swift
//  CareButtonToday
//
//  Created by Hiroka Yago on 2018/03/04.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import UIKit
import NotificationCenter
import NativePopup
import RxSwift

class TodayViewController: UIViewController, NCWidgetProviding {

    @IBOutlet weak var collectionView: UICollectionView!
    private var data: [CareButtonPanel] = CareButtonDummyData.shared.getShortcutPanel()

    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCustomCell()
        ApplicationBuilder.setup(target: .appExtension).subscribe(onSuccess: { () in
            self.collectionView.reloadData()
        }).disposed(by: disposeBag)
    }

    private func setupCustomCell() {
        let nib = UINib(nibName: TodayViewController.cellNibName, bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: TodayViewController.cellIdentifier)
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.newData)
    }

}

extension TodayViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    private static let cellIdentifier = "Cell"
    private static let cellNibName = "CareButtonCollectionViewCell"
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {

        return data.count

    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayViewController.cellIdentifier, for: indexPath)
        guard let careButtonCell = cell as? CareButtonCollectionViewCell else {
            fatalError("invalid cell type")
        }

        //AutoLayoutが適用された後に、TapのEffectを中心に配置したいため、ここで再度レイアウトする
        cell.layoutIfNeeded()

        if indexPath.row >= data.count {
            logger.error("coludn't find data. indexPath.row:\(indexPath.row)")
            return careButtonCell
        }

        let careButtonPanel = data[indexPath.row]
        //ボタンは名前ではなくて、時間を表示する
        careButtonCell.setWithLatestTime(careButtonPanel)
        careButtonCell.place = .todayExtension
        careButtonCell.set(delegate: self)

        return careButtonCell
    }
}

extension TodayViewController: CareButtonCollectionViewCellDelegate {

    func careButtonCollectionViewCell(_ viewCell: CareButtonCollectionViewCell) {
        guard let selectedCareButtonPanel = viewCell.careButtonPanel else {
            logger.error("not found careButtonPanel")
            return
        }
        guard selectedCareButtonPanel.operation == .normal else {
            fatalError("invalid")
        }

        guard let selectedCareButton = selectedCareButtonPanel.button else {
            logger.error("invalid")
            return
        }

        pushedCareButton(careButton: selectedCareButton)

        //押したというアクション

    }

    private func pushedCareButton(careButton: CareButton) {
        CareButtonEventLogDummyData.onPushOnToday(careButton: careButton)
    }
   /*
    private func showCareButtonActionViewController(careButtonPanel: CareButtonPanel) {
     
        let storyboard = UIStoryboard(name: "CareButtonActionViewController", bundle: nil)
        let nextNC = storyboard.instantiateInitialViewController() as! UINavigationController
        nextNC.modalTransitionStyle = .coverVertical
        let nextVC = nextNC.viewControllers[0] as! CareButtonActionViewController
        nextVC.set(careButtonPanel)
        //nextVC.transitioningDelegate = orgTransition
        
        self.present(nextNC, animated: true, completion: nil)

    } */

}
