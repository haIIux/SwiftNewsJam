import ComposableArchitecture
import SwiftUI

struct RSSListView: View {
  let store: Store<RSSListState, RSSListAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        if viewStore.isFetchingData {
          ProgressView()
        } else {
          Form {
            ForEachStore(
              store.scope(
                state: \.feeds,
                action: RSSListAction.feed
              ),
              content: { feedStore in
                WithViewStore(feedStore) { feedViewStore in
                  NavigationLink(feedViewStore.title, destination: RSSFeedView(store: feedStore))
                }
              }
            )
          }
        }
      }
      .onAppear {
        viewStore.send(.fetchFeeds)
      }
      .navigationTitle("RSS Feeds")
    }
  }
}

struct RSSListView_Preview: PreviewProvider {
  static var previews: some View {
    NavigationView {
      RSSListView(
        store: Store(
          initialState: RSSListState(
            feeds: [
              RSSFeed(
                id: .init(),
                title: "Some RSS Feed",
                url: URL(string: "SomeURL")!,
                articles: [
                ],
                isFetchingData: false
              )
            ],
            isFetchingData: false
          ),
          reducer: rssListReducer,
          environment: RSSListEnvironment(
            mainQueue: .main,
            fetchFeeds: {
              Effect(
                value: [
                  RSSFeed(
                    id: .init(),
                    title: "Some RSS Feed",
                    url: URL(string: "SomeURL")!,
                    articles: [
                    ],
                    isFetchingData: false
                  ),
                  RSSFeed(
                    id: .init(),
                    title: "Some other RSS Feed",
                    url: URL(string: "SomeURL")!,
                    articles: [
                    ],
                    isFetchingData: false
                  ),
                  RSSFeed(
                    id: .init(),
                    title: "Some weird RSS Feed",
                    url: URL(string: "SomeURL")!,
                    articles: [
                    ],
                    isFetchingData: false
                  )
                ]
              )
            },
            fetchArticles: { _ in
              Effect(
                value: [
                    RSSArticle(id: .init(), title: "Some RSS Article", link: "https://www.swiftbysundell.com/podcast/108", content: "Blah"),
                    RSSArticle(id: .init(), title: "Some other RSS Article", link: "https://www.swiftbysundell.com/podcast/108", content: "Blah"),
                    RSSArticle(id: .init(), title: "Some werid RSS Article", link: "https://www.swiftbysundell.com/podcast/108", content: "Blah")
                ]
              )
            }
          )
        )
      )
    }
  }
}
