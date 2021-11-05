import ComposableArchitecture
import SwiftUI

struct RSSFeedView: View {
  let store: Store<RSSFeed, RSSFeedAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        if viewStore.isFetchingData {
          ProgressView()
        } else {
          Form {
            ForEach(viewStore.articles) { article in
              NavigationLink(article.title, destination: RSSArticleView(article: article))
            }
          }
        }
      }
      .onAppear {
        viewStore.send(.fetchArticles)
      }
      .navigationTitle(viewStore.title)
    }
  }
}

struct RSSFeedView_Preview: PreviewProvider {
  static var previews: some View {
    NavigationView {
      RSSFeedView(
        store: Store(
          initialState: RSSFeed(
            id: .init(),
            title: "Some RSS Feed",
            url: URL(string: "SomeURL")!,
            articles: [
            
            ],
            isFetchingData: false
          ),
          reducer: rssFeedReducer,
          environment: RSSFeedEnvironment(
            mainQueue: .main,
            fetchArticles: { _ in
              Effect(
                value: [
                  RSSArticle(id: .init(), title: "Some RSS Article", contents: "Blah"),
                  RSSArticle(id: .init(), title: "Some other RSS Article", contents: "Blah"),
                  RSSArticle(id: .init(), title: "Some werid RSS Article", contents: "Blah")
                ]
              )
            }
          )
        )
      )
    }
  }
}

