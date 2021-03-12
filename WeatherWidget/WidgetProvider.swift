//
//  WidgetProvider.swift
//  Weather
//
//  Created by Samuel Shi on 3/11/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
  var widgetLocationManager = WidgetLocationManager()
  
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), locationName: "Cupertino", isCurrent: true, weather: OneCallResponse.example())
  }
  
  func getSnapshot(for configuration: LocationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), locationName: "Cupertino", isCurrent: true, weather: OneCallResponse.example())
    completion(entry)
  }
  
  func getTimeline(for configuration: LocationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
    var isCurrent = false
    if let name = configuration.city?.displayString {
      isCurrent = name == "My Location"
    }
    
    if !isCurrent, let latitude = configuration.city?.latitude, let longitude = configuration.city?.longitude {
      API.fetch(
        type: OneCallResponse.self,
        urlString: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=imperial",
        decodingStrategy: .convertFromSnakeCase
      ) { result in
        let weatherInfo: OneCallResponse
        var name: String
        
        if case .success(let fetchedData) = result {
          weatherInfo = fetchedData
        } else {
          name = "Error"
          weatherInfo = .example()
        }
        name = configuration.city?.displayString ?? "Error"
        
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .second, value: 30, to: currentDate)!
        let entry = SimpleEntry(date: currentDate, locationName: name, isCurrent: false, weather: weatherInfo)
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        completion(timeline)
      }
    } else {
      widgetLocationManager.fetchLocation { location in
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        API.fetch(
          type: OneCallResponse.self,
          urlString: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=imperial",
          decodingStrategy: .convertFromSnakeCase
        ) { result in
          let weatherInfo: OneCallResponse
          var name: String = ""
          
          if case .success(let fetchedData) = result {
            weatherInfo = fetchedData
          } else {
            name = "Error"
            weatherInfo = .example()
          }
          
          widgetLocationManager.lookUpCurrentLocation { placemark in
            if let placemark = placemark {
              name = placemark.locality!
            } else {
              name = "error"
            }
            
            let currentDate = Date()
            let refreshDate = Calendar.current.date(byAdding: .second, value: 10, to: currentDate)!
            let entry = SimpleEntry(date: currentDate, locationName: name, isCurrent: true, weather: weatherInfo)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
          }
        }
      }
    }
  }
}
