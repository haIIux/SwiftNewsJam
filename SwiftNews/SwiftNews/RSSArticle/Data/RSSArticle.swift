import Foundation
import ComposableArchitecture

struct RSSArticle: Equatable, Identifiable {
    var id: UUID
    
    var title: String
    var description: String
    var link: String
    var pubDate: String
    var content: String
    
    var isFavorite: Bool = false
}

enum RSSArticleAction: Equatable {
    case toggleFavorite
    case saveFavorite
}

struct RSSArticleEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    
    var saveFavorite: (RSSArticle) -> Void
}

extension RSSArticleEnvironment {
    static var mock = RSSArticleEnvironment(
        mainQueue: .main,
        saveFavorite: { article in
            UserDefaults.standard.set(article.isFavorite, forKey: "favorite.\(article.link)")
        }
    )
}

let rssArticleReducer = Reducer<RSSArticle, RSSArticleAction, RSSArticleEnvironment> { state, action, environment in
    switch action {
    case .toggleFavorite:
        state.isFavorite.toggle()
        return Effect(value: .saveFavorite)
        
    case .saveFavorite:
        environment.saveFavorite(state)
        
        return .none
    }
}
