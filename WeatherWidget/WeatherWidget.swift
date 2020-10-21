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
    SimpleEntry(date: Date(), locationName: "Cupertino", weather: OneCallResponse.blankInit())
  }
  
  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), locationName: "Cupertino", weather: OneCallResponse.blankInit())
    completion(entry)
  }
  
  var widgetLocationManager = WidgetLocationManager()
  
  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    let currentDate = Date()
    let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
    let currentLocation = readContents().current
    
    let latitude = currentLocation.lat
    let longitude = currentLocation.lon
    
    API.fetch(
      type: OneCallResponse.self,
      urlString: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=imperial",
      decodingStrategy: .convertFromSnakeCase
    ) { result in
      let weatherInfo: OneCallResponse
      var name = "Nothing"
    
      if case .success(let fetchedData) = result {
        name = currentLocation.name
        weatherInfo = fetchedData
      } else {
        name = "Error"
        let errWeather = OneCallResponse.blankInit()
        weatherInfo = errWeather
      }
    
      let entry = SimpleEntry(date: currentDate, locationName: name, weather: weatherInfo)
      let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
      completion(timeline)
    }
  }
  
  func readContents() -> Locations {
    var contents: Locations = Locations.staticInit()
    let archiveURL = FileManager.sharedContainerURL().appendingPathComponent("contents.json")
    
    let decoder = JSONDecoder()
    if let codeData = try? Data(contentsOf: archiveURL) {
      do {
        contents = try decoder.decode(Locations.self, from: codeData)
      } catch {
        print("Error: Can't decode contents")
      }
    }
    return contents
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let locationName: String
  let weather: OneCallResponse
}

struct WeatherWidgetEntryView : View {
  var entry: Provider.Entry
  
  var body: some View {
    WidgetView(name: entry.locationName, weather: entry.weather)
  }
}

@main
struct WeatherWidget: Widget {
  let kind: String = "WeatherWidget"
  
  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
      WeatherWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

//let currentDate = Date()
//let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
//let currentLocation = readContents().current
//
//let latitude = currentLocation.lat
//let longitude = currentLocation.lon
//
//API.fetch(
//  type: OneCallResponse.self,
//  urlString: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=imperial",
//  decodingStrategy: .convertFromSnakeCase
//) { result in
//  let weatherInfo: OneCallResponse
//  var name = "Nothing"
//
//  if case .success(let fetchedData) = result {
//    name = currentLocation.name
//    weatherInfo = fetchedData
//  } else {
//    name = "Error"
//    let errWeather = OneCallResponse.blankInit()
//    weatherInfo = errWeather
//  }
//
//  let entry = SimpleEntry(date: currentDate, locationName: name, weather: weatherInfo)
//  let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
//  completion(timeline)
//}
