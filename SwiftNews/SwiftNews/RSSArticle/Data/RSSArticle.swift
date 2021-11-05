import Foundation

struct RSSArticle: Equatable, Identifiable {
  var id: UUID
  
  var title: String
  var contents: String
}
