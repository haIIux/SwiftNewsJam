import ComposableArchitecture
import Foundation

// MARK: - State

struct RSSFeed: Equatable, Identifiable {
    var id: UUID
    var title: String
    var url: URL
    var articles: [RSSArticle] = []
    
    var isFetchingData: Bool = false
    var feeds: FeedURL = .sundell
}

// MARK: - Actions

struct RSSFeedError: Error, Equatable {}

enum RSSFeedAction: Equatable {
  case fetchArticles
  case loaded(articles: Result<[RSSArticle], RSSFeedError>)
}

// MARK: - Environment

struct RSSFeedEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var fetchArticles: (URL) -> Effect<[RSSArticle], RSSFeedError>
}

extension RSSFeedEnvironment {
  static var mock = RSSFeedEnvironment(
    mainQueue: .main,
    fetchArticles: { _ in
      Effect(
        value: (1 ... 100).map {
          RSSArticle(id: .init(), title: "Article #\($0)", contents: "Blah")
        }
      )
    }
  )
}

// MARK: - Reducer

let rssFeedReducer = Reducer<RSSFeed, RSSFeedAction, RSSFeedEnvironment> { state, action, environment in
  switch action {
  case .fetchArticles:
    state.isFetchingData = true
      
//      print(state.feeds)
      
      #warning("I don't feel like this is right... but I'm unsure how to properly test this to see if it's right. Brain farts :( ")
      return environment.fetchArticles(state.feeds.feedLinks)
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
