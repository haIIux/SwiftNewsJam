//
//  CategoryTemp.swift
//  SwiftNews
//
//  Created by Rob Maltese on 11/7/21.
//

import SwiftUI
import ComposableArchitecture

struct CategoryState: Equatable {
    var feed: FeedURL
    var availableFeeds: [FeedURL]
}

enum CategoryActions: Equatable {
    case selectFeed(FeedURL)
}

let categoryReducer = Reducer<CategoryState, CategoryActions, Void > { state, action, _ in
    switch action {
    case .selectFeed(let feedURL) :
        state.feed = feedURL
        return .none
    }
}

struct CategoriesView: View {
    let store: Store<CategoryState, CategoryActions>
    
    let rows = [
        GridItem(.fixed(50)),
        GridItem(.fixed(50))
    ]
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView(.horizontal) {
                LazyHGrid(rows: rows, alignment: .center) {
                    ForEach(viewStore.availableFeeds, id: \.self) { item in
                        Button {
                            viewStore.send(.selectFeed(item))
                        } label: {
                            Text(item.description)
                                .frame(minWidth: 75, idealWidth: 150, maxWidth: 175, minHeight: 25, idealHeight: 50, maxHeight: 100, alignment: .center)
                                .background(viewStore.feed == item ? Color.blue : Color.clear)
                                .foregroundColor(viewStore.feed == item ? .white : .blue)
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12)
                                            .stroke()
                                )
                        }
                    }
                }
                .padding(.leading, 5)
            }
        }
    }
}

struct CategoryTemp_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(store: .init(initialState: CategoryState.init(feed: .sundell, availableFeeds: FeedURL.allCases), reducer: categoryReducer, environment: ()))
    }
}
