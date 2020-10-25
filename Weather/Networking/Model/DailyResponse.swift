//
//  DailyResponseModel.swift
//  Weather
//
//  Created by Samuel Shi on 10/14/20.
//

import Foundation

struct DailyResponse: Codable {
  var dt: Int
  var sunrise: Int
  var sunset: Int
  var temp: Temperature
  var pop: Double
  
  var weather: [Weather]
  
  static func example() -> DailyResponse {
    DailyResponse(dt: 1595268000, sunrise: 1595243663, sunset: 1595296278, temp: Temperature(day: 75, min: 70, max: 80), pop: 1, weather: [Weather.example()])
  }
}
