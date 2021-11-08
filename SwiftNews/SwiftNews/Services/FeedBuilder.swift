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
import SwiftSoup

protocol FeedBuilder {
    var feedLink: URL { get }
    
    func fetch() -> Effect<[RSSArticle], FeedError>
}

enum FeedURL: String {
    case sundell = "https://swiftbysundell.com/rss"
    case sarunw = "https://sarunw.com/feed.xml"
    case apple = "https://developer.apple.com/news/rss/news.rss"
    case hackingwithswift = "https://www.hackingwithswift.com/articles/rss"
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

                    return xml.channel.xml?.item.xmlList?.compactMap { child -> RSSArticle? in
                        guard
                            let content = child[.key("content:encoded")].xml?.xmlValue,
                            let document = createDocument(from: content)
                        else { return nil }

                        return RSSArticle(
                            id: .init(),
                            title: child.title.xml?.xmlValue ?? "Title",
                            description: child[.key("description")].xml?.xmlValue ?? "Desc.",
                            link: child.link.xml?.xmlValue ?? "Link",
                            pubDate: child.pubDate.xml?.xmlValue ?? "Date",
                            content: content,
                            document: document
                        )
                    }
                }
                .eraseToEffect()
        }

    private func createDocument(from content: String) -> Document? {
        do {
            return try SwiftSoup.parse(content)
        } catch Exception.Error(let type, let message) {
            print("Message: \(message) of type : \(type).")
        } catch {
            print("Unknown error.")
        }
        return nil
    }
    
        
}
