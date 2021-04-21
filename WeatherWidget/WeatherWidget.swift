//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by Samuel Shi on 9/29/20.
//

import WidgetKit
import SwiftUI
import Intents

struct WeatherEntry: TimelineEntry {
  let date: Date
  let locationName: String
  let isCurrentLocation: Bool
  let weather: OneCallResponse
}

struct WeatherWidgetEntryView: View {
  var entry: Provider.Entry

  var body: some View {
    WidgetView(
      name: entry.locationName,
      isCurrent: entry.isCurrentLocation,
      weatherVM: WidgetViewModel(weather: entry.weather)
    )
  }
}

@main
struct WeatherWidget: Widget {
  let kind: String = "WeatherWidget"

  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: LocationIntent.self, provider: Provider()) { entry in
      WeatherWidgetEntryView(entry: entry)
    }
    .supportedFamilies([.systemMedium])
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}
