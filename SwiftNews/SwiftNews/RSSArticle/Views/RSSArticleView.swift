import SwiftUI

struct RSSArticleView: View {
  let article: RSSArticle
  
  var body: some View {
    VStack {
      Text(article.title)
        .font(.title)
        .padding()
      Spacer()
      Text(article.contents)
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
        author: "John Sundell",
        description: "An awesome article",
        contents: "Blah Blah Blah"
      )
    )
  }
}
