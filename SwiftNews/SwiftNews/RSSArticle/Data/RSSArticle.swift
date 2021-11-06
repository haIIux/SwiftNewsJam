import Foundation

struct RSSArticle: Equatable, Identifiable {
    var id: UUID
    
    var title: String
    var author: String
    var description: String
    var contents: String
}
