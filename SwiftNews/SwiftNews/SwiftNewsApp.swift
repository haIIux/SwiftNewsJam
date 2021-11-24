import ComposableArchitecture
import SwiftUI

@main
struct SwiftNewsApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationView {
        RSSFeedView(
            store: Store(
                initialState: RSSFeed(
                    id: .init(),
                    title: "Hacking with Swift",
                    articles: [],
                    isFetchingData: false,
                    feed: .hackingwithswift,
                    availableFeeds: FeedURL.allCases
                ),
                reducer: rssFeedReducer,
                environment: .live
            )
        )
      }
    }
  }
}
