import ComposableArchitecture
import SwiftUI

// MARK: - State

struct RSSFeed: Equatable, Identifiable {
    var id: UUID
    var title: String
    var articles: [RSSArticle] = []
    
    var isFetchingData: Bool = false
    var feed: FeedURL = .sundell
}

// MARK: - Actions

enum RSSFeedAction: Equatable {
    case fetchArticles
    case loaded(articles: Result<[RSSArticle], FeedError>)
}

// MARK: - Environment

struct RSSFeedEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var fetchArticles: (FeedURL) -> Effect<[RSSArticle], FeedError>
}

extension RSSFeedEnvironment {
    static var mock = RSSFeedEnvironment(
        mainQueue: .main,
        fetchArticles: { _ in
            Effect(
                value: (1 ... 100).map {
                    RSSArticle(id: .init(), title: "Article #\($0)", author: "John Sundell", description: "An awesome article", contents: "Blah")
                }
            )
        }
    )
    
    static var live = RSSFeedEnvironment(
        mainQueue: .main,
        fetchArticles: { feedURL in
            feedURL.fetch()
        }
    )
}

// MARK: - Reducer

let rssFeedReducer = Reducer<RSSFeed, RSSFeedAction, RSSFeedEnvironment> { state, action, environment in
    switch action {
    case .fetchArticles:
        state.isFetchingData = true
        return environment.fetchArticles(state.feed)
            .receive(on: environment.mainQueue)
            .catchToEffect(RSSFeedAction.loaded)
        
    case .loaded(articles: .failure):
        state.isFetchingData = false
        // TODO: Handle failure
        return .none
        
    case let .loaded(articles: .success(articles)):
        state.isFetchingData = false
        state.articles = articles
        return .none
    }
}
