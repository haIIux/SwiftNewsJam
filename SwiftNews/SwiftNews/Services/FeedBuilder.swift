//
//  URLBuilder.swift
//  SwiftNews
//
//  Created by Rob Maltese on 11/5/21.
//

import Foundation

/// Using protocol allows us to reuse the same setup for each feed we wish to include. This creates a `URLRequest` based off of our `path` which is appended to our `baseURL`. In our case, the `path` is typically always the same.
protocol FeedBuilder {
    var urlRequest: URLRequest { get }
    var baseURL: URL { get }
    var path: String { get }
}

/// Using an enum to build out our desired feeds will allow for easier switching between feeds once we build in categories.
/// Using our `FeedBuilder` we can take our `baseURL` and append it with our `path` in a more reusable fashion.
///
/// - Parameter baseURL: Takes our `baseURL` that we decide to switch on which will be our feed host.
/// - Parameter path: We will take our `path` and append it to our `baseURL` which in most cases, will be `/rss`.
///

enum FeedURL {
    case sundell
}

extension FeedURL: FeedBuilder {

    var urlRequest: URLRequest {
        return URLRequest(url: self.baseURL.appendingPathComponent((self.path)))
    }
    
    var baseURL: URL {
        switch self {
        case .sundell :
            return URL(string: "https://swiftbysundell.com")!
        }
    }

    var path: String {
        return "/rss"
    }
}
