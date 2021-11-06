import SwiftUI

struct RSSArticleView: View {
  let article: RSSArticle
  
  var body: some View {
    VStack {
      Text(article.title)
        .font(.title)
        .padding()
      Spacer()
      Text(article.content)
        .font(.body)
      Spacer()
    }
  }
}

struct RSSArticleView_Preview: PreviewProvider {
  static var previews: some View {
    RSSArticleView(
      article: RSSArticle(
        id: .init(),
        title: "Some RSS Article",
        link: "https://swiftbysundell/podcast/108",
        content: "Blah Blah Blah"
      )
    )
  }
}
