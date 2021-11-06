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
                    title: "Swift by Sundell",
                    articles: [],
                    isFetchingData: false,
                    feed: .sundell
                ),
                reducer: rssFeedReducer,
                environment: .live
            )
        )
      }
    }
  }
}
