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
}

let rssArticleReducer = Reducer<RSSArticle, RSSArticleAction, Void> { state, action, _ in
    switch action {
    case .toggleFavorite:
        state.isFavorite.toggle()
        return .none
    }
}
