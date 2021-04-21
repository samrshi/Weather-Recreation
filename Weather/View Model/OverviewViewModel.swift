//
//  OverviewViewModel.swift
//  Weather
//
//  Created by Samuel Shi on 10/25/20.
//

import Foundation

struct OverviewViewModel {

  let weather: OneCallResponse

  init(_ weather: OneCallResponse) {
    self.weather = weather
  }

  func overviewData() -> [DataGroup] {
    [
      DataGroup(
        title1: "Sunrise", data1: sunrise(),
        title2: "Sunset", data2: sunset()
      ),
      DataGroup(
        title1: "Chance of Rain", data1: precipitation(),
        title2: "Humidty", data2: humidity()
      ),
      DataGroup(
        title1: "Wind", data1: wind(),
        title2: "Pressure", data2: pressure()
      ),
      DataGroup(
        title1: "Visibility", data1: visibility(),
        title2: "UV Index", data2: uvi()
      )
    ]
  }

  func uvi() -> String {
   String(weather.current.uvi)
  }

  func visibility() -> String {
    let visibility = weather.current.visibility
    let metersToMiles = 1/1609.34
    let visibilityMiles = Int(visibility * metersToMiles)
    return "\(visibilityMiles) mi"
  }

  func pressure() -> String {
    let pressure = weather.current.pressure
    return "\(Int(pressure)) hPa"
  }

  func sunrise() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    let date = Date(timeIntervalSince1970: TimeInterval(weather.current.sunrise))
    return formatter.string(from: date)
  }

  func sunset() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    let date = Date(timeIntervalSince1970: TimeInterval(weather.current.sunset))
    return formatter.string(from: date)
  }

  func precipitation() -> String {
    let precip = Int(weather.hourly.first?.pop ?? 0 * 100)
    return "\(precip)%"
  }

  func humidity() -> String {
    let humidity = weather.current.humidity
    return "\(humidity)%"
  }

  func wind() -> String {
    let degrees = weather.current.windDeg
    var result = ""

    switch degrees {
    case 11.25..<33.75:
      result += "NNE"
    case 33.75..<56.25:
      result += "NE"
    case 56.25..<78.75:
      result += "ENE"
    case 78.75..<101.25:
      result += "E"
    case 101.25..<123.75:
      result += "ESE"
    case 123.75..<146.25:
      result += "SE"
    case 146.25..<168.75:
      result += "S"
    case 191.25...213.75:
      result += "SSW"
    case 213.75..<236.25:
      result += "SW"
    case 236.25..<258.75:
      result += "WSW"
    case 258.75..<281.25:
      result += "W"
    case 281.25..<303.75:
      result += "WNW"
    case 303.75..<326.25:
      result += "NNW"
    case 326.25 - 348.75:
      result += "NNW"
    default:
      result += "N"
    }

    result += " \(Int(weather.current.windSpeed)) mph"
    return result
  }
}

struct DataGroup: Hashable {
  let title1: String
  let data1: String
  let title2: String
  let data2: String
}
