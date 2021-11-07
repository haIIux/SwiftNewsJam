//
//  SwiftNewsWidget.swift
//  SwiftNewsWidget
//
//  Created by Hugo Mason on 07/11/2021.
//

import WidgetKit
import Combine
import SwiftUI

class Provider: TimelineProvider {
    var bag = Set<AnyCancellable>()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            articles: [
                RSSArticle(id: .init(), title: "Some RSS Article", description: "Blah Blah Blah", link: "some-link", pubDate: "Today", content: "...")
            ]
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        guard !context.isPreview else {
            completion(
                SimpleEntry(
                    date: Date(),
                    articles: [
                        RSSArticle(id: .init(), title: "Some RSS Article", description: "Blah Blah Blah", link: "some-link", pubDate: "Today", content: "...")
                    ]
                )
            )
            return
        }
        
        FeedURL.sundell.fetch()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { articles in
                    completion(
                        SimpleEntry(
                            date: Date(),
                            articles: articles
                        )
                    )
                }
            )
            .store(in: &bag)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        FeedURL.sundell.fetch()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { articles in
                    var entries: [SimpleEntry] = []
                    
                    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
                    let currentDate = Date()
                    for hourOffset in 0 ..< 5 {
                        let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                        let entry = SimpleEntry(
                            date: entryDate,
                            articles: Array(articles.dropFirst(3 * hourOffset).prefix(3))
                        )
                        entries.append(entry)
                    }
                    
                    let timeline = Timeline(entries: entries, policy: .atEnd)
                    completion(timeline)
                }
            )
            .store(in: &bag)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let articles: [RSSArticle]
}

struct SwiftNewsWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Text(entry.articles.first?.title ?? "Loading...")
        }
    }
}

@main
struct SwiftNewsWidget: Widget {
    let kind: String = "SwiftNewsWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SwiftNewsWidgetEntryView(
                entry: entry
            )
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
