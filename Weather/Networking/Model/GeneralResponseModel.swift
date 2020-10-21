//
//  GeneralResponseModel.swift
//  Weather
//
//  Created by Samuel Shi on 10/14/20.
//

import Foundation

struct GeneralResponse: Codable {
  var dt: Int
  
  var temp: Double
  var feelsLike: Double
  var humidity: Int
  var clouds: Double
  
  var weather: [Weather]
}

extension GeneralResponse {
  func formattedHour() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h"
    let date = Date(timeIntervalSince1970: TimeInterval(dt))
    
    return  Calendar.current.isDate(Date(), equalTo: date, toGranularity: .hour) ? "Now" : formatter.string(from: date)
  }
  
  func formattedPeriod() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "a"
    let date = Date(timeIntervalSince1970: TimeInterval(dt))
    
    return Calendar.current.isDate(Date(), equalTo: date, toGranularity: .hour) ? "" : formatter.string(from: date)
  }
  
  static func blankInit() -> GeneralResponse {
    GeneralResponse(dt: 1595243443, temp: 76 , feelsLike: 75, humidity: 50, clouds: 80, weather: [Weather.blankInit()])
  }
}
