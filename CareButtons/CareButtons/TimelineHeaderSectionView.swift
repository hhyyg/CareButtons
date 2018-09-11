//
//  TimelineHeaderSectionView.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/01/02.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import UIKit

class TimelineHeaderSectionView: UIView {

    @IBOutlet weak var containerView: UIView!
    static let containerViewRadius: CGFloat = 6

    static var dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()

    @IBOutlet weak var dateLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

        configure()
    }

    private func configure() {
        loadNib()

        containerView.layer.cornerRadius = TimelineHeaderSectionView.containerViewRadius
        containerView.layer.masksToBounds = true
    }

    private func loadNib() {
        let view = Bundle.main.loadNibNamed("TimelineHeaderSectionView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }

    func set(date: Date) {
        dateLabel.text = TimelineHeaderSectionView.dateFormatter.string(from: date)
    }
}
