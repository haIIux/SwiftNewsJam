import Foundation

struct RSSArticle: Equatable, Identifiable {
    var id: UUID
    
    var title: String
    var description: String
    var link: String
    var pubDate: String
    var content: String
}

