//
//  SlackAction.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/03/03.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import Foundation

class SlackActionFormatter {

    static var dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    static func ToText(log: CareButtonEventLog) -> String {

        var text = "\(dateFormatter.string(from: log.time)) \(log.name)"
        if let amount = log.amount,
            let amountUnitName = log.amountUnitName {
            text += " \(amount)\(amountUnitName)"
        }
        return text
    }

}

class SlackAction {

    private static let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        return session
    }()

    static func Action(log: CareButtonEventLog) {
        //TODO
        return

        let text = SlackActionFormatter.ToText(log: log)
        let payload = "payload={ \"username\": \"いっち\", \"icon_emoji\":\":baby:\", \"text\": \"\(text)\"}"
        let data = payload.data(using: .utf8)!

        let url = URL(string: "https://hooks.slack.com/services/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")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = data

        let task = session.dataTask(with: urlRequest) { data, response, error in
            switch (data, response, error) {
            case (_?, _, _):
                logger.debug("slack success")
            case (_, _, let error?):
                logger.error(error)
            default:
                assertionFailure()
            }
        }

        task.resume()
    }
}
