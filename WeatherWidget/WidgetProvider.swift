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
    if isCurrent {
      widgetLocationManager.fetchLocation { location in
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        fetchWeather(Double(latitude), Double(longitude)) { result in
          let weatherInfo: OneCallResponse
          var name: String = ""
          
          if case .success(let fetchedData) = result {
            weatherInfo = fetchedData
          } else {
            name = "Network Error"
            weatherInfo = .example()
          }
          
          widgetLocationManager.lookUpLocationName { placemark in
            if let placemark = placemark {
              name = placemark.locality!
            } else {
              name = "Geocoding Error"
            }
            
            updateTimeline(name: name, weather: weatherInfo, isCurrent: true, completion: completion)
          }
        }
      }
    } else if !isCurrent, let latitude = configuration.city?.latitude, let longitude = configuration.city?.longitude, let cityName = configuration.city?.displayString {
      fetchWeather(Double(truncating: latitude), Double(truncating: longitude)) { result in
        let weatherInfo: OneCallResponse
        var name: String
        
        if case .success(let fetchedData) = result {
          name = cityName
          weatherInfo = fetchedData
        } else {
          name = "Network Error"
          weatherInfo = .example()
        }
        
        updateTimeline(name: name, weather: weatherInfo, isCurrent: false, completion: completion)
      }
    }
  }
  
  func fetchWeather(_ latitude: Double, _ longitude: Double, completion: @escaping (Result<OneCallResponse, NetworkError>) -> Void) {
    API.fetch(
      type: OneCallResponse.self,
      urlString: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=imperial",
      decodingStrategy: .convertFromSnakeCase
    ) { result in
      completion(result)
    }
  }
  
  func updateTimeline(name: String, weather: OneCallResponse, isCurrent: Bool, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
    let currentDate = Date()
    let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
    let entry = SimpleEntry(date: currentDate, locationName: name, isCurrent: isCurrent, weather: weather)
    let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
    completion(timeline)
  }
}
