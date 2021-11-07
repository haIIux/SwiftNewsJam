//
//  CategoryTemp.swift
//  SwiftNews
//
//  Created by Rob Maltese on 11/7/21.
//

import SwiftUI

struct CategoryTemp: View {
    var categoryArray = ["SwiftBySundell", "Sarunw", "HackingWithSwift", "Ray Wenderlich", "Apple"]
    
    let rows = [
        GridItem(.fixed(50)),
        GridItem(.fixed(50))
    ]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows, alignment: .center) {
                ForEach(categoryArray, id: \.self) { item in
                    Text(item)
                        .frame(minWidth: 75, idealWidth: 150, maxWidth: 175, minHeight: 25, idealHeight: 50, maxHeight: 100, alignment: .center)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                    )
                }
            }
        }
        .padding(.horizontal, 5)
    }
}

struct CategoryTemp_Previews: PreviewProvider {
    static var previews: some View {
        CategoryTemp()
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
