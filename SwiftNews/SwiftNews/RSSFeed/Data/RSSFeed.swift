import ComposableArchitecture
import SwiftUI

// MARK: - State

struct RSSFeed: Equatable, Identifiable {
    var id: UUID
    var title: String
    var articles: IdentifiedArrayOf<RSSArticle> = []
    
    var isFetchingData: Bool = false
    var feed: FeedURL = .sundell
    
    var favoriteArticles: [String] = []
}

// MARK: - Actions

enum RSSFeedAction: Equatable {
    case fetchArticles
    case loaded(articles: Result<[RSSArticle], FeedError>)
    
    case article(id: RSSArticle.ID, action: RSSArticleAction)
}

// MARK: - Environment

struct RSSFeedEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var fetchArticles: (FeedURL) -> Effect<[RSSArticle], FeedError>
}

extension RSSFeedEnvironment {
    static var mock = RSSFeedEnvironment(
        mainQueue: .main,
        fetchArticles: { _ in
            Effect(
                value: (1 ... 100).map {
                    RSSArticle(
                        id: .init(),
                        title: "Article #\($0)",
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
                }
            )
        }
    )
    
    static var live = RSSFeedEnvironment(
        mainQueue: .main,
        fetchArticles: { feedURL in
            feedURL.fetch()
        }
    )
    
}

// MARK: - Reducer

let rssFeedReducer = Reducer<RSSFeed, RSSFeedAction, RSSFeedEnvironment>
    .combine(
        rssArticleReducer
            .forEach(
                state: \RSSFeed.articles,
                action: /RSSFeedAction.article,
                environment: { _ in () }
            ),
        
        Reducer { state, action, environment in
            switch action {
            case .fetchArticles:
                state.isFetchingData = true
                return environment.fetchArticles(state.feed)
                    .receive(on: environment.mainQueue)
                    .catchToEffect(RSSFeedAction.loaded)
                
            case .loaded(articles: .failure):
                state.isFetchingData = false
                // TODO: Handle failure
                return .none
                
            case let .loaded(articles: .success(articles)):
                state.isFetchingData = false
                state.articles = IdentifiedArray(
                    uniqueElements: articles.map { article in
                        if state.favoriteArticles.contains(article.link) {
                            return RSSArticle(
                                id: article.id,
                                title: article.title,
                                description: article.description,
                                link: article.link,
                                pubDate: article.pubDate,
                                content: article.content,
                                isFavorite: true
                            )
                        } else {
                            return article
                        }
                    }
                )
                return .none
                
            case .article:
                state.favoriteArticles = state.articles.filter(\.isFavorite).map(\.link)
                return .none
            }
            
        }
    )

