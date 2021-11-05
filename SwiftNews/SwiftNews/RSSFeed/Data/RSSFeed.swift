import ComposableArchitecture

// MARK: - State

struct RSSFeed: Equatable, Identifiable {
  var id: UUID
  var title: String
  var url: URL // Possibly this needs to be defined as FeedBuilder so we can grab the FeedURL?
  var articles: [RSSArticle] = []
  
  var isFetchingData: Bool = false
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
    // Once connected I believe this is how it would go...
//    var fetchArticles: (FeedURL) -> Effect<[RSSArticle], RSSFeedError>
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
    return environment.fetchArticles(state.url)
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
