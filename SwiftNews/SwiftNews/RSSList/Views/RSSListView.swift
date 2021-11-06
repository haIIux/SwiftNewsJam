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
                    RSSArticle(id: .init(), title: "Some RSS Article",
                               link: "https://www.swiftbysundell.com/podcast/108",
                               pubDate: "Thu, 4 Nov 2021 19:35:00",
                               content:
                                    """
                                            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Venenatis cras sed felis eget velit aliquet sagittis id consectetur. Massa sapien faucibus et molestie ac feugiat sed lectus. In hendrerit gravida rutrum quisque non tellus. Et ligula ullamcorper malesuada proin libero nunc consequat. Viverra adipiscing at in tellus integer. A condimentum vitae sapien pellentesque habitant morbi. Feugiat pretium nibh ipsum consequat nisl vel pretium lectus quam. Volutpat sed cras ornare arcu dui. Sapien eget mi proin sed libero enim sed faucibus. Faucibus turpis in eu mi bibendum neque egestas congue quisque.
                                            
                                            Et ultrices neque ornare aenean euismod. Viverra vitae congue eu consequat. Mauris a diam maecenas sed enim ut sem. Lobortis elementum nibh tellus molestie nunc non. Tincidunt id aliquet risus feugiat in ante metus. Ullamcorper morbi tincidunt ornare massa eget. Tortor dignissim convallis aenean et. Diam vulputate ut pharetra sit amet. Senectus et netus et malesuada fames. Eget aliquet nibh praesent tristique magna sit amet. Enim praesent elementum facilisis leo vel fringilla est ullamcorper. A diam sollicitudin tempor id eu.
                                    
                                            Hac habitasse platea dictumst quisque sagittis purus sit. Sagittis purus sit amet volutpat consequat mauris nunc congue nisi. Sed risus ultricies tristique nulla aliquet enim. At augue eget arcu dictum varius duis at. Id aliquet lectus proin nibh nisl condimentum id. Accumsan lacus vel facilisis volutpat est velit egestas. Elementum tempus egestas sed sed risus pretium quam vulputate. Odio tempor orci dapibus ultrices in iaculis nunc. Aenean et tortor at risus viverra adipiscing. Eget gravida cum sociis natoque. Enim facilisis gravida neque convallis a cras.
                                    """
                              ),
                    RSSArticle(id: .init(), title: "Some other RSS Article",
                               link: "https://www.swiftbysundell.com/podcast/108",
                               pubDate: "Thu, 4 Nov 2021 19:35:00",
                               content:
                                  """
                                          Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Venenatis cras sed felis eget velit aliquet sagittis id consectetur. Massa sapien faucibus et molestie ac feugiat sed lectus. In hendrerit gravida rutrum quisque non tellus. Et ligula ullamcorper malesuada proin libero nunc consequat. Viverra adipiscing at in tellus integer. A condimentum vitae sapien pellentesque habitant morbi. Feugiat pretium nibh ipsum consequat nisl vel pretium lectus quam. Volutpat sed cras ornare arcu dui. Sapien eget mi proin sed libero enim sed faucibus. Faucibus turpis in eu mi bibendum neque egestas congue quisque.
                                          
                                          Et ultrices neque ornare aenean euismod. Viverra vitae congue eu consequat. Mauris a diam maecenas sed enim ut sem. Lobortis elementum nibh tellus molestie nunc non. Tincidunt id aliquet risus feugiat in ante metus. Ullamcorper morbi tincidunt ornare massa eget. Tortor dignissim convallis aenean et. Diam vulputate ut pharetra sit amet. Senectus et netus et malesuada fames. Eget aliquet nibh praesent tristique magna sit amet. Enim praesent elementum facilisis leo vel fringilla est ullamcorper. A diam sollicitudin tempor id eu.
                                  
                                          Hac habitasse platea dictumst quisque sagittis purus sit. Sagittis purus sit amet volutpat consequat mauris nunc congue nisi. Sed risus ultricies tristique nulla aliquet enim. At augue eget arcu dictum varius duis at. Id aliquet lectus proin nibh nisl condimentum id. Accumsan lacus vel facilisis volutpat est velit egestas. Elementum tempus egestas sed sed risus pretium quam vulputate. Odio tempor orci dapibus ultrices in iaculis nunc. Aenean et tortor at risus viverra adipiscing. Eget gravida cum sociis natoque. Enim facilisis gravida neque convallis a cras.
                                  """
                              ),
                    RSSArticle(id: .init(), title: "Some werid RSS Article",
                               link: "https://www.swiftbysundell.com/podcast/108",
                               pubDate: "Thu, 4 Nov 2021 19:35:00",
                               content:
                                  """
                                          Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Venenatis cras sed felis eget velit aliquet sagittis id consectetur. Massa sapien faucibus et molestie ac feugiat sed lectus. In hendrerit gravida rutrum quisque non tellus. Et ligula ullamcorper malesuada proin libero nunc consequat. Viverra adipiscing at in tellus integer. A condimentum vitae sapien pellentesque habitant morbi. Feugiat pretium nibh ipsum consequat nisl vel pretium lectus quam. Volutpat sed cras ornare arcu dui. Sapien eget mi proin sed libero enim sed faucibus. Faucibus turpis in eu mi bibendum neque egestas congue quisque.
                                          
                                          Et ultrices neque ornare aenean euismod. Viverra vitae congue eu consequat. Mauris a diam maecenas sed enim ut sem. Lobortis elementum nibh tellus molestie nunc non. Tincidunt id aliquet risus feugiat in ante metus. Ullamcorper morbi tincidunt ornare massa eget. Tortor dignissim convallis aenean et. Diam vulputate ut pharetra sit amet. Senectus et netus et malesuada fames. Eget aliquet nibh praesent tristique magna sit amet. Enim praesent elementum facilisis leo vel fringilla est ullamcorper. A diam sollicitudin tempor id eu.
                                  
                                          Hac habitasse platea dictumst quisque sagittis purus sit. Sagittis purus sit amet volutpat consequat mauris nunc congue nisi. Sed risus ultricies tristique nulla aliquet enim. At augue eget arcu dictum varius duis at. Id aliquet lectus proin nibh nisl condimentum id. Accumsan lacus vel facilisis volutpat est velit egestas. Elementum tempus egestas sed sed risus pretium quam vulputate. Odio tempor orci dapibus ultrices in iaculis nunc. Aenean et tortor at risus viverra adipiscing. Eget gravida cum sociis natoque. Enim facilisis gravida neque convallis a cras.
                                  """
                              )
                ]
              )
            }
          )
        )
      )
    }
  }
}
