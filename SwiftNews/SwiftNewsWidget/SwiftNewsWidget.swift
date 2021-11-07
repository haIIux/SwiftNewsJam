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
                RSSArticle(id: .init(), title: "Lorem ipsum dolor sit amet.", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus pharetra quis turpis id sollicitudin. Praesent id turpis lorem. Vestibulum pellentesque.", link: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam in.", pubDate: "Today", content: "...")
            ]
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        guard !context.isPreview else {
            completion(
                SimpleEntry(
                    date: Date(),
                    articles: [
                        RSSArticle(id: .init(), title: "Lorem ipsum dolor sit amet.", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus pharetra quis turpis id sollicitudin. Praesent id turpis lorem. Vestibulum pellentesque.", link: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam in.", pubDate: "Today", content: "...")
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
    
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            VStack(alignment: .leading) {
                Text(entry.articles.first?.title ?? "Loading...")
                    .bold()
                    .padding(.top, 10)
                    .padding(.leading, 5)
                
                Text(entry.articles.first?.pubDate ?? "Loading...")
                    .font(.subheadline)
                    .padding(.bottom, 8)
                    .padding(.leading, 5)
            }
        case .systemMedium:
            VStack(alignment: .leading) {
                Text(entry.articles.first?.title ?? "Loading...")
                    .bold()
                    .padding(.top, 10)
                    .padding(.leading, 5)
                    .padding(.bottom, 2)
                
                Text(entry.articles.first?.description ?? "Loading...")
                    .font(.subheadline)
                    .padding(.bottom, 7)
                    .padding(.leading, 5)
                    .frame(alignment: .center)
                
                Text(entry.articles.first?.pubDate ?? "Loading...")
                    .font(.subheadline)
                    .padding(.bottom, 8)
                    .padding(.leading, 5)
            }
        default:
            VStack(alignment: .leading) {
                Text(entry.articles.first?.title ?? "Loading...")
                    .bold()
                    .padding(.top, 10)
                    .padding(.leading, 5)
                
                Text(entry.articles.first?.pubDate ?? "Loading...")
                    .font(.subheadline)
                    .padding(.bottom, 8)
                    .padding(.leading, 5)
            }
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
        .configurationDisplayName("Swift News Widget")
        .description("These widgets show the title and publishing date of the most recent article. The medium widget has a description for the article.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
