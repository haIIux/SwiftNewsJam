import ComposableArchitecture
import SwiftUI

struct RSSFeedView: View {
    let store: Store<RSSFeed, RSSFeedAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                if viewStore.isFetchingData && viewStore.articles.isEmpty {
                    ProgressView()
                } else {
                    Form {
                        if !viewStore.favoriteArticles.isEmpty {
                            Section(
                                content: {
                                    ForEachStore(
                                        store.scope(
                                            state: \.favoriteArticles,
                                            action: RSSFeedAction.favoriteArticle
                                        ),
                                        content: { rssArticleStore in
                                            WithViewStore(rssArticleStore) { rssArticleViewStore in
                                                NavigationLink(destination: RSSArticleView(store: rssArticleStore)) {
                                                    VStack(alignment: .leading) {
                                                        HStack {
                                                            Text(rssArticleViewStore.title)
                                                                .bold()
                                                        }
                                                        Spacer()
                                                        
                                                        Text(rssArticleViewStore.description)
                                                            .font(.caption)
                                                    }
                                                }
                                            }
                                        }
                                    )
                                },
                                header: {
                                    Text("Favorites")
                                }
                            )
                        }
                        
                        if !viewStore.nonFavoriteArticles.isEmpty {
                            Section {
                                ForEachStore(
                                    store.scope(
                                        state: \.nonFavoriteArticles,
                                        action: RSSFeedAction.nonFavoriteArticle
                                    ),
                                    content: { rssArticleStore in
                                        WithViewStore(rssArticleStore) { rssArticleViewStore in
                                            NavigationLink(destination: RSSArticleView(store: rssArticleStore)) {
                                                VStack(alignment: .leading) {
                                                    HStack {
                                                        Text(rssArticleViewStore.title)
                                                            .bold()
                                                        
                                                    }
                                                    Spacer()
                                                    
                                                    Text(rssArticleViewStore.description)
                                                        .font(.caption)
                                                }
                                            }
                                        }
                                    }
                                )
                            }
                        }
                    }
                }
            }
            .onAppear {
                viewStore.send(.didAppear)
            }
            .refreshable {
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
                                    RSSArticle(
                                        id: .init(),
                                        title: "Some RSS Article",
                                        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                                        link: "https://www.swiftbysundell.com/podcast/108",
                                        pubDate: "Thu, 4 Nov 2021 19:35:00",
                                        content:
                                    """
                                            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Venenatis cras sed felis eget velit aliquet sagittis id consectetur. Massa sapien faucibus et molestie ac feugiat sed lectus. In hendrerit gravida rutrum quisque non tellus. Et ligula ullamcorper malesuada proin libero nunc consequat. Viverra adipiscing at in tellus integer. A condimentum vitae sapien pellentesque habitant morbi. Feugiat pretium nibh ipsum consequat nisl vel pretium lectus quam. Volutpat sed cras ornare arcu dui. Sapien eget mi proin sed libero enim sed faucibus. Faucibus turpis in eu mi bibendum neque egestas congue quisque.
                                            
                                            Et ultrices neque ornare aenean euismod. Viverra vitae congue eu consequat. Mauris a diam maecenas sed enim ut sem. Lobortis elementum nibh tellus molestie nunc non. Tincidunt id aliquet risus feugiat in ante metus. Ullamcorper morbi tincidunt ornare massa eget. Tortor dignissim convallis aenean et. Diam vulputate ut pharetra sit amet. Senectus et netus et malesuada fames. Eget aliquet nibh praesent tristique magna sit amet. Enim praesent elementum facilisis leo vel fringilla est ullamcorper. A diam sollicitudin tempor id eu.
                                    
                                            Hac habitasse platea dictumst quisque sagittis purus sit. Sagittis purus sit amet volutpat consequat mauris nunc congue nisi. Sed risus ultricies tristique nulla aliquet enim. At augue eget arcu dictum varius duis at. Id aliquet lectus proin nibh nisl condimentum id. Accumsan lacus vel facilisis volutpat est velit egestas. Elementum tempus egestas sed sed risus pretium quam vulputate. Odio tempor orci dapibus ultrices in iaculis nunc. Aenean et tortor at risus viverra adipiscing. Eget gravida cum sociis natoque. Enim facilisis gravida neque convallis a cras.
                                    """
                                    ),
                                    RSSArticle(
                                        id: .init(),
                                        title: "Some other RSS Article",
                                        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                                        link: "https://www.swiftbysundell.com/podcast/108",
                                        pubDate: "Thu, 4 Nov 2021 19:35:00",
                                        content:
                                  """
                                          Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Venenatis cras sed felis eget velit aliquet sagittis id consectetur. Massa sapien faucibus et molestie ac feugiat sed lectus. In hendrerit gravida rutrum quisque non tellus. Et ligula ullamcorper malesuada proin libero nunc consequat. Viverra adipiscing at in tellus integer. A condimentum vitae sapien pellentesque habitant morbi. Feugiat pretium nibh ipsum consequat nisl vel pretium lectus quam. Volutpat sed cras ornare arcu dui. Sapien eget mi proin sed libero enim sed faucibus. Faucibus turpis in eu mi bibendum neque egestas congue quisque.
                                          
                                          Et ultrices neque ornare aenean euismod. Viverra vitae congue eu consequat. Mauris a diam maecenas sed enim ut sem. Lobortis elementum nibh tellus molestie nunc non. Tincidunt id aliquet risus feugiat in ante metus. Ullamcorper morbi tincidunt ornare massa eget. Tortor dignissim convallis aenean et. Diam vulputate ut pharetra sit amet. Senectus et netus et malesuada fames. Eget aliquet nibh praesent tristique magna sit amet. Enim praesent elementum facilisis leo vel fringilla est ullamcorper. A diam sollicitudin tempor id eu.
                                  
                                          Hac habitasse platea dictumst quisque sagittis purus sit. Sagittis purus sit amet volutpat consequat mauris nunc congue nisi. Sed risus ultricies tristique nulla aliquet enim. At augue eget arcu dictum varius duis at. Id aliquet lectus proin nibh nisl condimentum id. Accumsan lacus vel facilisis volutpat est velit egestas. Elementum tempus egestas sed sed risus pretium quam vulputate. Odio tempor orci dapibus ultrices in iaculis nunc. Aenean et tortor at risus viverra adipiscing. Eget gravida cum sociis natoque. Enim facilisis gravida neque convallis a cras.
                                  """
                                    ),
                                    RSSArticle(
                                        id: .init(),
                                        title: "Some werid RSS Article",
                                        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
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
                        },
                        saveFavorite: {
                            UserDefaults.standard.set($0.isFavorite, forKey: "favorite.\($0.link)")
                        }
                    )
                )
            )
        }
    }
}
