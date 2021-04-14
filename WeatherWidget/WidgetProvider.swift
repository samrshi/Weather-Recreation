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
  
  func placeholder(in context: Context) -> WeatherEntry {
    WeatherEntry(date: Date(), locationName: "Cupertino", isCurrentLocation: true, weather: OneCallResponse.example())
  }
  
  func getSnapshot(
    for configuration: LocationIntent,
    in context: Context,
    completion: @escaping (WeatherEntry) -> ()
  ) {
    let entry = WeatherEntry(
      date: Date(),
      locationName: "Cupertino",
      isCurrentLocation: true,
      weather: OneCallResponse.example()
    )
    completion(entry)
  }
  
  func getTimeline(
    for configuration: LocationIntent,
    in context: Context,
    completion: @escaping (Timeline<WeatherEntry>) -> ()
  ) {
    var isCurrent = false
    if let name = configuration.city?.displayString {
      isCurrent = name == .myLocation
    }
    if isCurrent {
      updateTimeLineForCurrent(completion: completion)
    } else {
      updateTimeLineForSpecific(configuration: configuration, completion: completion)
    }
  }
  
  func updateTimeLineForCurrent(
    completion: @escaping (Timeline<WeatherEntry>) -> ()
  ) {
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
            name += "Geocoding Error"
          }
          
          updateTimeline(
            name: name,
            weather: weatherInfo,
            isCurrentLocation: true,
            completion: completion
          )
        }
      }
    }
  }
  
  func updateTimeLineForSpecific(
    configuration: LocationIntent,
    completion: @escaping (Timeline<WeatherEntry>) -> ()
  ) {
    if let latitude = configuration.city?.latitude,
       let longitude = configuration.city?.longitude,
       let cityName = configuration.city?.displayString
    {
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
        
        updateTimeline(
          name: name,
          weather: weatherInfo,
          isCurrentLocation: false,
          completion: completion
        )
      }
    }
  }
  
  func fetchWeather(
    _ latitude: Double,
    _ longitude: Double,
    completion: @escaping (Result<OneCallResponse, NetworkError>) -> Void
  ) {
    Network.fetch(
      type: OneCallResponse.self,
      urlString: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=imperial",
      decodingStrategy: .convertFromSnakeCase
    ) { result in
      completion(result)
    }
  }
  
  func updateTimeline(
    name: String,
    weather: OneCallResponse,
    isCurrentLocation: Bool,
    completion: @escaping (Timeline<WeatherEntry>) -> ()
  ) {
    let currentDate = Date()
    let calendar = Calendar.current
    let refreshDate = calendar.date(byAdding: .minute, value: 5, to: currentDate)!
    let entry = WeatherEntry(
      date: currentDate,
      locationName: name,
      isCurrentLocation: isCurrentLocation,
      weather: weather
    )
    let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
    completion(timeline)
  }
}
