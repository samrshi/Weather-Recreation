//
//  String+Icon.swift
//  Weather
//
//  Created by Samuel Shi on 10/24/20.
//

import SwiftUI

extension String {
  func symbol() -> String {
    var image: String = "xmark"
    
    switch self {
    case "01d":
      image = "sun.max.fill"
    case "01n":
      image = "moon.stars.fill"
    case "02d":
      image = "cloud.sun.fill"
    case "02n":
      image = "cloud.moon.fill"
    case "03d":
      image = "cloud.fill"
    case "03n":
      image = "cloud.fill"
    case "04d":
      image = "cloud.fill"
    case "04n":
      image = "cloud.fill"
    case "09d":
      image = "cloud.rain.fill"
    case "09n":
      image = "cloud.rain.fill"
    case "10d":
      image = "cloud.sun.rain.fill"
    case "10n":
      image = "cloud.moon.rain.fill"
    case "11d":
      image = "cloud.bolt.rain.fill"
    case "11n":
      image = "cloud.bolt.rain.fill"
    case "13d":
      image = "snow"
    case "13n":
      image = "snow"
    case "50d":
      image = "cloud.drizzle.fill"
    case "50n":
      image = "cloud.drizzle.fill"
    default:
      break
    }
    return image
  }
}
