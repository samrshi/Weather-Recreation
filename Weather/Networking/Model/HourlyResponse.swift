//
//  HourlyResponse.swift
//  Weather
//
//  Created by Samuel Shi on 10/24/20.
//

import Foundation

struct HourlyResponse: Codable {
  var dt: Int
  
  var temp: Double
  var feelsLike: Double
  var humidity: Int
  var clouds: Double
  var pop: Double
  
  var weather: [Weather]
  
  static func example() -> HourlyResponse {
    HourlyResponse(dt: 1595243443, temp: 76 , feelsLike: 75, humidity: 50, clouds: 80, pop: 0.99, weather: [Weather.example()])
  }
}
