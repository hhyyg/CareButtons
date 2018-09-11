//
//  TimelineViewController.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2017/12/29.
//  Copyright © 2017 Hiroka Yago. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {

    @IBOutlet weak var timelineTableView: UITableView!

    private var data: [(key: Date, value: [CareButtonEventLog])] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        timelineTableView.register(UINib(nibName: TimelineViewController.cellNibName, bundle: nil), forCellReuseIdentifier: TimelineViewController.cellIdentifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //TODO 二重
        data = CareButtonEventLogDummyData.getGrouping()

        timelineTableView.reloadData()
    }

}

extension TimelineViewController: UITableViewDelegate, UITableViewDataSource {

    private static let cellIdentifier = "TimelineTableViewCell"
    private static let cellNibName = "TimelineTableViewCell"

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let date = data.map { $0.key }[section]
        guard let sectionLogs = (data.first { $0.key == date }) else {
            fatalError("not found")
        }
        return sectionLogs.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = timelineTableView.dequeueReusableCell(withIdentifier: TimelineViewController.cellIdentifier, for: indexPath)

        guard let eventLogCell = cell as? TimelineTableViewCell else {
            fatalError("invalid cell type")
        }

//
//        if indexPath.row >= elements.count {
//            logger.error("coludn't find data. indexPath.row:\(indexPath.row)")
//            return eventLogCell
//        }

        let date = data.map { $0.key }[indexPath.section]
        guard let sectionLogs = (data.first { $0.key == date }) else {
            fatalError("not found")
        }

        let eventLog = sectionLogs.value[indexPath.row]
        eventLogCell.set(eventLog)

        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        if indexPath.row >= elements.count {
//            logger.error("coludn't find data. indexPath.row:\(indexPath.row)")
//            return
//        }

        let date = data.map { $0.key }[indexPath.section]
        guard let sectionLogs = (data.first { $0.key == date }) else {
            fatalError("not found")
        }

        let eventLog = sectionLogs.value[indexPath.row]

        guard let careButton = eventLog.baseCareButton else {
            //ダミーデータもあるので空のログが存在する
            logger.info("selected empty careButton log")
            return
        }
        //編集
        showCareButtonActionViewController(careButton: careButton)
    }

    private func showCareButtonActionViewController(careButton: CareButton) {
        let storyboard = UIStoryboard(name: "CareButtonActionViewController", bundle: nil)
        let nextNC = storyboard.instantiateInitialViewController() as! UINavigationController
        let nextVC = nextNC.viewControllers[0] as! CareButtonActionViewController
        nextVC.mode = .edit
        nextVC.set(careButton)

        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

         let date = data.map { $0.key }[section]

        let headerView = TimelineHeaderSectionView()
        headerView.set(date: date)
        return headerView
    }

}
