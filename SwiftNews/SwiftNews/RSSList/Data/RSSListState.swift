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
  var fetchArticles: (URL) -> Effect<[RSSArticle], RSSFeedError>
}

extension RSSListEnvironment {
  static var mock = RSSListEnvironment(
    mainQueue: .main,
    fetchFeeds: {
      Effect(
        value: (1 ... 100).map {
          RSSFeed(id: .init(), title: "RSS Feed #\($0)", url: URL(string: "SomeURL")!)
        }
      )
    },
    fetchArticles: { _ in
      Effect(
        value: (1 ... 100).map {
            RSSArticle(id: .init(), title: "Article #\($0)",
                       link: "https://www.swiftbysundell.com/podcast/108",
                       content:
                        """
                                Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Venenatis cras sed felis eget velit aliquet sagittis id consectetur. Massa sapien faucibus et molestie ac feugiat sed lectus. In hendrerit gravida rutrum quisque non tellus. Et ligula ullamcorper malesuada proin libero nunc consequat. Viverra adipiscing at in tellus integer. A condimentum vitae sapien pellentesque habitant morbi. Feugiat pretium nibh ipsum consequat nisl vel pretium lectus quam. Volutpat sed cras ornare arcu dui. Sapien eget mi proin sed libero enim sed faucibus. Faucibus turpis in eu mi bibendum neque egestas congue quisque.
                                
                                Et ultrices neque ornare aenean euismod. Viverra vitae congue eu consequat. Mauris a diam maecenas sed enim ut sem. Lobortis elementum nibh tellus molestie nunc non. Tincidunt id aliquet risus feugiat in ante metus. Ullamcorper morbi tincidunt ornare massa eget. Tortor dignissim convallis aenean et. Diam vulputate ut pharetra sit amet. Senectus et netus et malesuada fames. Eget aliquet nibh praesent tristique magna sit amet. Enim praesent elementum facilisis leo vel fringilla est ullamcorper. A diam sollicitudin tempor id eu.
                        
                                Hac habitasse platea dictumst quisque sagittis purus sit. Sagittis purus sit amet volutpat consequat mauris nunc congue nisi. Sed risus ultricies tristique nulla aliquet enim. At augue eget arcu dictum varius duis at. Id aliquet lectus proin nibh nisl condimentum id. Accumsan lacus vel facilisis volutpat est velit egestas. Elementum tempus egestas sed sed risus pretium quam vulputate. Odio tempor orci dapibus ultrices in iaculis nunc. Aenean et tortor at risus viverra adipiscing. Eget gravida cum sociis natoque. Enim facilisis gravida neque convallis a cras.
                        """
            )
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
