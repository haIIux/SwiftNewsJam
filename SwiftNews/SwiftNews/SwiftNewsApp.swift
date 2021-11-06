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
                    title: "swiftbysundell",
                    articles: [],
                    isFetchingData: false,
                    feed: .sundell
                ),
                reducer: rssFeedReducer,
                environment: .mock // .live
            )
        )
      }
    }
  }
}
