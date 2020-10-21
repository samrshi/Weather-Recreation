//
//  WeatherModel.swift
//  Weather
//
//  Created by Samuel Shi on 10/14/20.
//

import Foundation
import SwiftUI

struct Weather: Codable {
  var id: Int
  var main: String
  var description: String
  var icon: String
}

extension Weather {
  func symbol() -> Image {
    var image: Image = Image(systemName: "xmark")
    
    switch icon {
    case "01d":
      image = Image(systemName: "sun.max.fill")
    case "01n":
      image = Image(systemName: "moon.fill")
    case "02d":
      image = Image(systemName: "cloud.sun.fill")
    case "02n":
      image = Image(systemName: "cloud.moon.fill")
    case "03d":
      image = Image(systemName: "cloud.fill")
    case "03n":
      image = Image(systemName: "cloud.fill")
    case "04d":
      image = Image(systemName: "cloud.fill")
    case "04n":
      image = Image(systemName: "cloud.fill")
    case "09d":
      image = Image(systemName: "cloud.rain.fill")
    case "09n":
      image = Image(systemName: "cloud.rain.fill")
    case "10d":
      image = Image(systemName: "cloud.sun.rain.fill")
    case "10n":
      image = Image(systemName: "cloud.moon.rain.fill")
    case "11d":
      image = Image(systemName: "cloud.bolt.rain.fill")
    case "11n":
      image = Image(systemName: "cloud.bolt.rain.fill")
    case "13d":
      image = Image(systemName: "snow")
    case "13n":
      image = Image(systemName: "snow")
    case "50d":
      image = Image(systemName: "cloud.drizzle.fill")
    case "50n":
      image = Image(systemName: "cloud.drizzle.fill")
    default:
      break
    }
    return image
  }
  
  static func blankInit() -> Weather {
    Weather(id: 501, main: "Rain", description: "moderate rain", icon: "10n")
  }
}
