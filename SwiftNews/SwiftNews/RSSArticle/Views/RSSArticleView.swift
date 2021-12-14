import ComposableArchitecture
import SwiftUI

struct RSSArticleView: View {
    let store: Store<RSSArticle, RSSArticleAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text(viewStore.title)
                            .bold()
                            .font(.title2)
                        Spacer()
                        Button {
                            viewStore.send(.toggleFavorite)
                        } label: {
                            Image(systemName: viewStore.isFavorite ?  "star.fill" : "star")
                                .font(.title2)
                        }
                        
                    }
                    Text(viewStore.pubDate)
                        .font(.caption)
                        .padding(.bottom, 5)
                    Link("View Web Version", destination: URL(string: viewStore.link)!)
                        .font(.caption)
                        .padding(.bottom, 5)
                    Text((try? viewStore.document?.text()) ?? viewStore.content)
                        .font(.body)
                }
                .padding(.horizontal)
            }
        }
    }
}

struct RSSArticleView_Preview: PreviewProvider {
    static var previews: some View {
        RSSArticleView(
            store: Store(
                initialState: RSSArticle(
                    id: .init(),
                    title: "Some RSS Article",
                    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                    link: "https://swiftbysundell/podcast/108",
                    pubDate: "Thu, 4 Nov 2021 19:35:00",
                    content: """
                        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Venenatis cras sed felis eget velit aliquet sagittis id consectetur. Massa sapien faucibus et molestie ac feugiat sed lectus. In hendrerit gravida rutrum quisque non tellus. Et ligula ullamcorper malesuada proin libero nunc consequat. Viverra adipiscing at in tellus integer. A condimentum vitae sapien pellentesque habitant morbi. Feugiat pretium nibh ipsum consequat nisl vel pretium lectus quam. Volutpat sed cras ornare arcu dui. Sapien eget mi proin sed libero enim sed faucibus. Faucibus turpis in eu mi bibendum neque egestas congue quisque.
                        
                        Et ultrices neque ornare aenean euismod. Viverra vitae congue eu consequat. Mauris a diam maecenas sed enim ut sem. Lobortis elementum nibh tellus molestie nunc non. Tincidunt id aliquet risus feugiat in ante metus. Ullamcorper morbi tincidunt ornare massa eget. Tortor dignissim convallis aenean et. Diam vulputate ut pharetra sit amet. Senectus et netus et malesuada fames. Eget aliquet nibh praesent tristique magna sit amet. Enim praesent elementum facilisis leo vel fringilla est ullamcorper. A diam sollicitudin tempor id eu.
                
                        Hac habitasse platea dictumst quisque sagittis purus sit. Sagittis purus sit amet volutpat consequat mauris nunc congue nisi. Sed risus ultricies tristique nulla aliquet enim. At augue eget arcu dictum varius duis at. Id aliquet lectus proin nibh nisl condimentum id. Accumsan lacus vel facilisis volutpat est velit egestas. Elementum tempus egestas sed sed risus pretium quam vulputate. Odio tempor orci dapibus ultrices in iaculis nunc. Aenean et tortor at risus viverra adipiscing. Eget gravida cum sociis natoque. Enim facilisis gravida neque convallis a cras.
                """
                ),
                reducer: rssArticleReducer,
                environment: .mock
            )
        )
    }
}
