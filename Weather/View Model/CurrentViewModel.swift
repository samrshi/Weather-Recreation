//
//  CurrentViewModel.swift
//  Weather
//
//  Created by Samuel Shi on 10/24/20.
//

import SwiftUI

struct CurrentViewModel {
  let weather: OneCallResponse
  
  init(_ response: OneCallResponse) {
    weather = response
  }
  
  func icon() -> Image {
    weather.current.weather.first?.icon.symbol() ?? Image(systemName: "photo")
  }
  
  func iconString() -> String {
    weather.current.weather.first?.icon ?? "01n"
  }
  
  func temperature() -> String {
    "\(Int(weather.current.temp))ºF"
  }
  
  func feelsLike() -> String {
    "Feels Like \(Int(weather.current.feelsLike))ºF"
  }
  
  func high() -> String {
    "High: \(Int(weather.daily.first?.temp.max ?? -1))º"
  }
  
  func low() -> String {
    "Low: \(Int(weather.daily.first?.temp.min ?? -1))º"
  }
  
  func description() -> String {
    weather.current.weather.first?.description.capitalized ?? ""
  }
}
