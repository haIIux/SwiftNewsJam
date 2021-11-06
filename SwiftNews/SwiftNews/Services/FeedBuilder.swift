//
//  URLBuilder.swift
//  SwiftNews
//
//  Created by Rob Maltese on 11/5/21.
//

import Foundation

/// Using protocol allows us to reuse the same setup for each feed we wish to include.  In our case, the `/rss` is typically always the same.
protocol FeedBuilder {
    var feedLinks: URL { get }
}

/// Using an enum to build out our desired feeds will allow for easier switching between feeds once we build in categories.
/// Using our `FeedBuilder` we can take our `baseURL` and append it with  `/rss` in a more reusable fashion.
///
/// - Parameter baseURL: Takes our `baseURL` that we decide to switch on which will be our feed host.
///

enum FeedURL: String {
    case sundell = "https://swiftbysundell.com/rss"
    case sarunw = "https://sarunw.com/feed"
}

extension FeedURL: FeedBuilder {
    var feedLinks: URL {
        return URL(string: self.rawValue)!
    }
}
