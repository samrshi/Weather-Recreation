//
//  String+Icon.swift
//  Weather
//
//  Created by Samuel Shi on 10/24/20.
//

import SwiftUI

extension String {
  func symbol() -> String {
    switch self {
    case "01d":
      return "sun.max.fill"
    case "01n":
      return "moon.stars.fill"
    case "02d":
      return "cloud.sun.fill"
    case "02n":
      return "cloud.moon.fill"
    case "03d":
      return "cloud.fill"
    case "03n":
      return "cloud.fill"
    case "04d":
      return "cloud.fill"
    case "04n":
      return "cloud.fill"
    case "09d":
      return "cloud.rain.fill"
    case "09n":
      return "cloud.rain.fill"
    case "10d":
      return "cloud.sun.rain.fill"
    case "10n":
      return "cloud.moon.rain.fill"
    case "11d":
      return "cloud.bolt.rain.fill"
    case "11n":
      return "cloud.bolt.rain.fill"
    case "13d":
      return "snow"
    case "13n":
      return "snow"
    case "50d":
      return "cloud.drizzle.fill"
    case "50n":
      return "cloud.drizzle.fill"
    default:
      return "xmark"
    }
  }
}
