//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by Samuel Shi on 9/29/20.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), locationName: "Cupertino", isCurrent: true, weather: OneCallResponse.example())
  }
  
  func getSnapshot(for configuration: LocationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), locationName: "Cupertino", isCurrent: true, weather: OneCallResponse.example())
    completion(entry)
  }
    
  func getTimeline(for configuration: LocationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    let currentDate = Date()
    let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
    
    let current = FileManager.readContents().current
    
    let latitude = configuration.city?.latitude ?? NSNumber(value: current.lat)
    let longitude = configuration.city?.longitude ?? NSNumber(value: current.lon)
    
    var isCurrent = false
    if let name = configuration.city?.displayString {
      isCurrent = name == "My Location"
    }
    
    API.fetch(
      type: OneCallResponse.self,
      urlString: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=imperial",
      decodingStrategy: .convertFromSnakeCase
    ) { result in
      let weatherInfo: OneCallResponse
      var name = "Nothing"
    
      if case .success(let fetchedData) = result {
        name = configuration.city?.identifier ?? "None"
        weatherInfo = fetchedData
      } else {
        name = "Error"
        let errWeather = OneCallResponse.example()
        weatherInfo = errWeather
      }
    
      let entry = SimpleEntry(date: currentDate, locationName: name, isCurrent: isCurrent, weather: weatherInfo)
      let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
      completion(timeline)
    }
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let locationName: String
  let isCurrent: Bool
  let weather: OneCallResponse
}

struct WeatherWidgetEntryView : View {
  var entry: Provider.Entry
  
  var body: some View {
    WidgetView(name: entry.locationName, isCurrent: entry.isCurrent, weatherVM: WidgetViewModel(weather: entry.weather))
  }
}

@main
struct WeatherWidget: Widget {
  let kind: String = "WeatherWidget"
  
  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: LocationIntent.self, provider: Provider()) { entry in
      WeatherWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}
