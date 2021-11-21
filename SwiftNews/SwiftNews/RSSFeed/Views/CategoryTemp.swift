//
//  CategoryTemp.swift
//  SwiftNews
//
//  Created by Rob Maltese on 11/7/21.
//

import SwiftUI

enum CatTemp: String, CaseIterable {
    case sundell   = "https://swiftbysundell.com/rss"
    case sarunw  = "https://sarunw.com/feed.xml"
    case apple   = "https://developer.apple.com/news/rss/news.rss"
    case hackingwithswift = "https://www.hackingwithswift.com/articles/rss"
    
    var description: String {
        switch self {
        case .sundell:
            return "Swift by Sundell"
        case .sarunw:
            return "Sarunw"
        case .apple:
            return "Apple"
        case .hackingwithswift:
            return "Hacking with Swift"
        }
    }
}

struct CategoryTemp: View {
    var categoryArray = ["SwiftBySundell", "Sarunw", "HackingWithSwift", "Ray Wenderlich", "Apple"]
    
    @State var categories: FeedURL
    
    let rows = [
        GridItem(.fixed(50)),
        GridItem(.fixed(50))
    ]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows, alignment: .center) {
                ForEach(FeedURL.allCases, id: \.self) { item in
                    Button {
                        print("Button Tapped \(item.description)")
                    } label: {
                        Text(item.description)
                            .frame(minWidth: 75, idealWidth: 150, maxWidth: 175, minHeight: 25, idealHeight: 50, maxHeight: 100, alignment: .center)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2)
                        )
                    }
                }
            }
            .padding(.leading, 5)
        }
    }
}

struct CategoryTemp_Previews: PreviewProvider {
    static var previews: some View {
        CategoryTemp(categories: FeedURL.sundell)
    }
}

/*
 HStack {
     ForEach(categoryArray, id: \.self) { item in
         Text(item)
             .padding()
             .overlay(
                 RoundedRectangle(cornerRadius: 10)
                     .stroke(lineWidth: 2)
         )
     }
 }
 .padding(5)

 */
