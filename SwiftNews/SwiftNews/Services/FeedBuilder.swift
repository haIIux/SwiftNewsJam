//
//  URLBuilder.swift
//  SwiftNews
//
//  Created by Rob Maltese on 11/5/21.
//

import Foundation

/// Using protocol allows us to reuse the same setup for each feed we wish to include.  In our case, the `/rss` is typically always the same.
protocol FeedBuilder {
    var baseURL: URL { get }
}

/// Using an enum to build out our desired feeds will allow for easier switching between feeds once we build in categories.
/// Using our `FeedBuilder` we can take our `baseURL` and append it with  `/rss` in a more reusable fashion.
///
/// - Parameter baseURL: Takes our `baseURL` that we decide to switch on which will be our feed host.
///

enum FeedURL {
    case sundell
    case sarunw
}

extension FeedURL: FeedBuilder {
    var baseURL: URL {
        switch self {
        case .sundell :
            return URL(string: "https://swiftbysundell.com/rss")!
        case .sarunw :
            return URL(string: "https://sarunw.com/feed")!
        }
    }

}
