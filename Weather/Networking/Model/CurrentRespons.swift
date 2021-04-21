//
//  GeneralResponseModel.swift
//  Weather
//
//  Created by Samuel Shi on 10/14/20.
//

import Foundation

struct CurrentResponse: Codable {
  var dt: Int

  var temp: Double
  var feelsLike: Double
  var humidity: Int
  var clouds: Double
  var sunrise: Int
  var sunset: Int
  var windSpeed: Double
  var windDeg: Double
  var pressure: Double
  var uvi: Double
  var visibility: Double

  var weather: [Weather]

  static func example() -> CurrentResponse {
    CurrentResponse(
      dt: 1595243443,
      temp: 76 ,
      feelsLike: 75,
      humidity: 50,
      clouds: 80,
      sunrise: 1595243443,
      sunset: 1595243443,
      windSpeed: 4.6,
      windDeg: 310,
      pressure: 1000,
      uvi: 0,
      visibility: 6437,
      weather: [Weather.example()]
    )
  }
}
