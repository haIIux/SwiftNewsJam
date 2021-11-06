import ComposableArchitecture

// MARK: - State

struct RSSListState: Equatable {
  var feeds: IdentifiedArrayOf<RSSFeed> = []
  
  var isFetchingData: Bool = false
}

// MARK: - Actions

struct RSSListError: Error, Equatable {}

enum RSSListAction: Equatable {
  case fetchFeeds
  case loaded(feeds: Result<[RSSFeed], RSSListError>)
  
  case feed(id: RSSFeed.ID, action: RSSFeedAction)
}

// MARK: - Environment

struct RSSListEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>
  
  var fetchFeeds: () -> Effect<[RSSFeed], RSSListError>
  var fetchArticles: (FeedURL) -> Effect<[RSSArticle], FeedError>
}

extension RSSListEnvironment {
  static var mock = RSSListEnvironment(
    mainQueue: .main,
    fetchFeeds: {
      Effect(
        value: (1 ... 100).map {
          RSSFeed(id: .init(), title: "RSS Feed #\($0)")
        }
      )
    },
    fetchArticles: { _ in
      Effect(
        value: (1 ... 100).map {
          RSSArticle(id: .init(), title: "Article #\($0)", author: "John Sundell", description: "An awesome article", contents: "Blah")
        }
      )
    }
  )
  
  // TODO: `.live`
  /*
   static var live = RSSListEnvironment(
     mainQueue: .main,
     fetchFeeds: {
     
     },
     fetchArticles: { _ in
     
     }
   )
   */
}

// MARK: - Reducer

let rssListReducer = Reducer<RSSListState, RSSListAction, RSSListEnvironment>
  .combine(
    rssFeedReducer
      .forEach(
        state: \RSSListState.feeds,
        action: /RSSListAction.feed,
        environment: {
          RSSFeedEnvironment(
            mainQueue: $0.mainQueue,
            fetchArticles: $0.fetchArticles
          )
        }
      ),
    Reducer { state, action, environment in
      switch action {
      case .fetchFeeds:
        state.isFetchingData = true
        return environment.fetchFeeds()
          .receive(on: environment.mainQueue)
          .catchToEffect(RSSListAction.loaded)
        
      case .loaded(feeds: .failure):
        state.isFetchingData = false
        // TODO: Handle failure
        return .none
        
      case let .loaded(feeds: .success(feeds)):
        state.isFetchingData = false
        state.feeds = IdentifiedArray(uniqueElements: feeds)
        return .none
        
      case .feed:
        return .none
      }
    }
  )
