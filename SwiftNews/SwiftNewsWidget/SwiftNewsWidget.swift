//
//  SwiftNewsWidget.swift
//  SwiftNewsWidget
//
//  Created by Hugo Mason on 07/11/2021.
//

import WidgetKit
import SwiftUI
import ComposableArchitecture
import SwiftyXML

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct SwiftNewsWidgetEntryView : View {
    let store: Store<RSSFeed, RSSFeedAction>
    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

@main
struct SwiftNewsWidget: Widget {
    let kind: String = "SwiftNewsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SwiftNewsWidgetEntryView(store: Store(
                    initialState: RSSFeed(
                        id: .init(),
                        title: "Swift by Sundell",
                        articles: [],
                        isFetchingData: false,
                        feed: .sundell
                    ),
                    reducer: rssFeedReducer,
                    environment: .live), entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
