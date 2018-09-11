//
//  EnumCollection.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/04/11.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import Foundation
public protocol EnumCollection: Hashable {
    static var allValues: [Self] { get }
}

public extension EnumCollection {
    static func cases() -> AnySequence<Self> {
        typealias SelfType = Self
        return AnySequence { () -> AnyIterator<SelfType> in
            var raw = 0
            return AnyIterator {
                let current: Self = withUnsafePointer(to: &raw) {
                    $0.withMemoryRebound(to: SelfType.self, capacity: 1) { $0.pointee }
                }
                guard current.hashValue == raw else { return nil }
                raw += 1
                return current
            }
        }
    }
    static var allValues: [Self] {
        return Array(self.cases())
    }
}
