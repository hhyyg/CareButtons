//
//  CareButtonsViewController.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2017/12/27.
//  Copyright © 2017 Hiroka Yago. All rights reserved.
//

import UIKit
import NativePopup

class CareButtonsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private var data: [CareButtonPanel] = CareButtonDummyData.shared.getData()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCustomCell()
    }

    private func setupCustomCell() {
        let nib = UINib(nibName: CareButtonsViewController.cellNibName, bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: CareButtonsViewController.cellIdentifier)
    }

}

extension CareButtonsViewController: UICollectionViewDataSource, UICollectionViewDelegate {

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

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CareButtonsViewController.cellIdentifier, for: indexPath)
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
        careButtonCell.set(careButtonPanel)
        careButtonCell.set(delegate: self)

        return careButtonCell
    }
}

extension CareButtonsViewController: CareButtonCollectionViewCellDelegate {

    func careButtonCollectionViewCell(_ viewCell: CareButtonCollectionViewCell) {
        guard let selectedCareButtonPanel = viewCell.careButtonPanel else {
            logger.error("not found careButtonPanel")
            return
        }
        guard selectedCareButtonPanel.operation == .normal else {
            //TODO:
            return
        }

        guard let selectedCareButton = selectedCareButtonPanel.button else {
            logger.error("invalid")
            return
        }

        if selectedCareButton.requireInputAdditionalInfo {
            showCareButtonActionViewController(careButtonPanel: selectedCareButtonPanel)
        } else {
            pushedCareButton(careButton: selectedCareButton)
        }

    }

    private func pushedCareButton(careButton: CareButton) {
        CareButtonEventLogDummyData.onPush(careButton: careButton)
        NativePopup.show(image: UIImage(named: "nice")!, title: "\(careButton.name)", message: nil)
    }

    private func showCareButtonActionViewController(careButtonPanel: CareButtonPanel) {
        let storyboard = UIStoryboard(name: "CareButtonActionViewController", bundle: nil)
        let nextNC = storyboard.instantiateInitialViewController() as! UINavigationController
        nextNC.modalTransitionStyle = .coverVertical
        let nextVC = nextNC.viewControllers[0] as! CareButtonActionViewController
        nextVC.set(careButtonPanel)
        //nextVC.transitioningDelegate = orgTransition

        self.present(nextNC, animated: true, completion: nil)
    }

}
