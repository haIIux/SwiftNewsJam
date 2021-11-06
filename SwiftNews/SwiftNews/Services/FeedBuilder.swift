//
//  URLBuilder.swift
//  SwiftNews
//
//  Created by Rob Maltese on 11/5/21.
//

import Foundation

protocol FeedBuilder {
    var feedLinks: URL { get }
}

enum FeedURL: String {
    case sundell = "https://swiftbysundell.com/rss"
    case sarunw = "https://sarunw.com/feed"
}

extension FeedURL: FeedBuilder {
    var feedLinks: URL {
        return URL(string: self.rawValue)!
    }
}
