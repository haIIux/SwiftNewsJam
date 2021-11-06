import Foundation

struct RSSArticle: Equatable, Identifiable {
    var id: UUID
    
    var title: String
    var link: String
    var content: String
}
