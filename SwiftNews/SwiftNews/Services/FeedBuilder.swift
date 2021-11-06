//
//  URLBuilder.swift
//  SwiftNews
//
//  Created by Rob Maltese on 11/5/21.
//

import Combine
import Foundation
import ComposableArchitecture
import SwiftyXML

protocol FeedBuilder {
    var feedLink: URL { get }
    
    func fetch() -> Effect<[RSSArticle], FeedError>
}

enum FeedURL: String {
    case sundell = "https://swiftbysundell.com/rss"
    case sarunw = "https://sarunw.com/feed.xml"
}

extension FeedURL: FeedBuilder {
    var feedLink: URL {
        return URL(string: self.rawValue)!
    }
    
    func fetch() -> Effect<[RSSArticle], FeedError> {
        URLSession.shared
            .dataTaskPublisher(for: feedLink)
            .mapError { _ in
                FeedError.unknown
            }
            .compactMap {
                let xml = XML(data: $0.data)!
                
                return xml.channel.xml?.item.xmlList?.compactMap { (child) -> RSSArticle in
                    RSSArticle(
                        id: .init(),
                        title: child.title.xml?.xmlValue ?? "Title",
                        author: "The Internet",
                        description: child[.key("description")].xml?.xmlValue ?? "Desc.",
                        contents: child[.key("content:encoded")].xml?.xmlValue ?? "Contents"
                    )
                }
            }
            .eraseToEffect()
        
    }
}
