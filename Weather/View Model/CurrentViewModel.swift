//
//  CurrentViewModel.swift
//  Weather
//
//  Created by Samuel Shi on 10/24/20.
//

import SwiftUI

struct CurrentViewModel {
  let weather: OneCallResponse
  let isWidget: Bool

  init(_ response: OneCallResponse, isWidget: Bool = false) {
    weather = response
    self.isWidget = isWidget
  }

  func icon() -> String {
    weather.current.weather.first?.icon.symbol() ?? "photo"
  }

  func iconRaw() -> String {
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

  func getBackgroundColors() -> [Color] {
    let str = iconRaw()
    switch str.last {
    case "d":
      return .day
    case "n":
      return .night
    default:
      return [.black]
    }
  }

  func formattedDate() -> String {
    let calendar = Calendar.current
    let date = Date(timeIntervalSince1970: TimeInterval(weather.current.dt))
    let sameDay = calendar.isDate(date, equalTo: Date(), toGranularity: .day)
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(secondsFromGMT: weather.timezoneOffset)

    formatter.dateFormat = "\(sameDay ? "'Today'" : "E,") h:mm a"
    return formatter.string(from: date)
  }
}
