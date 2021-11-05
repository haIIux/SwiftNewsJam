import ComposableArchitecture
import SwiftUI

@main
struct SwiftNewsApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationView {
        RSSListView(
          store: Store(
            initialState: RSSListState(),
            reducer: rssListReducer,
            environment: .mock // TODO: .live
          )
        )
      }
    }
  }
}
