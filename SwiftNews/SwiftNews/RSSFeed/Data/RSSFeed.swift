import ComposableArchitecture
import SwiftUI
import SwiftSoup

// MARK: - State

struct RSSFeed: Equatable, Identifiable {
    var id: UUID
    var title: String
    var articles: IdentifiedArrayOf<RSSArticle> = []
    
    var isFetchingData: Bool = false
    
    // State for Category View.
    var feed: FeedURL = .sundell
    var availableFeeds: [FeedURL]
    var categoryState: CategoryState {
        get {
            CategoryState(
                feed: self.feed,
                availableFeeds: self.availableFeeds
            )
        }
        
        set {
            self.feed = newValue.feed
            self.availableFeeds = newValue.availableFeeds
        }
    }
    
    var favoriteArticles: IdentifiedArrayOf<RSSArticle> = []
    var nonFavoriteArticles: IdentifiedArrayOf<RSSArticle> = []
    
    var isFirstLoad: Bool = true
}


// MARK: - Actions

enum RSSFeedAction: Equatable {
    case didAppear
    case updateFavoriteSections
    case fetchArticles
    case loaded(articles: Result<[RSSArticle], FeedError>)
    
    case favoriteArticle(id: RSSArticle.ID, action: RSSArticleAction)
    case nonFavoriteArticle(id: RSSArticle.ID, action: RSSArticleAction)
    
    case category(CategoryActions)
}

// MARK: - Environment

struct RSSFeedEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var fetchArticles: (FeedURL) -> Effect<[RSSArticle], FeedError>
    var saveFavorite: (RSSArticle) -> Void
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
        },
        saveFavorite: {
            UserDefaults.standard.set($0.isFavorite, forKey: "favorite.\($0.link)")
        }
    )
    
    static var live = RSSFeedEnvironment(
        mainQueue: .main,
        fetchArticles: { feedURL in
            feedURL.fetch()
        },
        saveFavorite: {
            UserDefaults.standard.set($0.isFavorite, forKey: "favorite.\($0.link)")
        }
    )
}

// MARK: - Reducer

let rssFeedReducer = Reducer<RSSFeed, RSSFeedAction, RSSFeedEnvironment>
    .combine(
        rssArticleReducer
            .forEach(
                state: \RSSFeed.favoriteArticles,
                action: /RSSFeedAction.favoriteArticle,
                environment: {
                    RSSArticleEnvironment(
                        mainQueue: $0.mainQueue,
                        saveFavorite: $0.saveFavorite
                    )
                }
            ),
        
        categoryReducer
            .pullback(state: \RSSFeed.categoryState,
                      action: /RSSFeedAction.category,
                      environment: {_ in ()}
                     ),
        
        rssArticleReducer
            .forEach(
                state: \RSSFeed.nonFavoriteArticles,
                action: /RSSFeedAction.nonFavoriteArticle,
                environment: {
                    RSSArticleEnvironment(
                        mainQueue: $0.mainQueue,
                        saveFavorite: $0.saveFavorite
                    )
                }
            ),
        
        Reducer { state, action, environment in
            switch action {
            case .didAppear:
                return state.isFirstLoad ? Effect(value: .fetchArticles) : Effect(value: .updateFavoriteSections)
                
            case .updateFavoriteSections:
                state.favoriteArticles.forEach {
                    state.articles.updateOrAppend($0)
                }
                state.nonFavoriteArticles.forEach {
                    state.articles.updateOrAppend($0)
                }
                state.favoriteArticles = state.articles.filter(\.isFavorite)
                state.nonFavoriteArticles = state.articles.filter { !$0.isFavorite }
                return .none
                
            case .fetchArticles:
                state.isFetchingData = true
                state.isFirstLoad = false
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
                        RSSArticle(
                            id: article.id,
                            title: article.title,
                            description: article.description,
                            link: article.link,
                            pubDate: article.pubDate,
                            content: article.content,
                            document: article.document,
                            isFavorite: UserDefaults.standard.bool(forKey: "favorite.\(article.link)")
                        )
                    }
                        .sorted { $0.isFavorite && !$1.isFavorite }
                )
                
                return Effect(value: .updateFavoriteSections)
                
            case .nonFavoriteArticle, .favoriteArticle, .category:
                return .none
            }
        }
    )
