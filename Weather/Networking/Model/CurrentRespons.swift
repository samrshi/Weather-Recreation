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
  
  var weather: [Weather]
  
  static func example() -> CurrentResponse {
    CurrentResponse(dt: 1595243443, temp: 76 , feelsLike: 75, humidity: 50, clouds: 80, weather: [Weather.example()])
  }
}

