//
//  WeatherManager.swift
//  Weather
//
//  Created by Samuel Shi on 9/28/20.
//

import Foundation
import SwiftUI

struct OneCallResponse: Codable {
  var lat: Double
  var lon: Double
  var timezone: String
  var timezoneOffset: Int
  
  var current: CurrentResponse
  var hourly: [HourlyResponse]
  var daily: [DailyResponse]
  
  static func example() -> OneCallResponse {
    OneCallResponse(lat: 40.12, lon: -96.66, timezone: "America/Chicago", timezoneOffset: -18000, current: CurrentResponse.example(), hourly: [HourlyResponse.example()], daily: [DailyResponse.example()])
  }
}

extension OneCallResponse {
  func formattedDate() -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(current.dt))
    let sameDay = Calendar.current.isDate(date, equalTo: Date(), toGranularity: .day)
    let formatter = DateFormatter()
    
    formatter.dateFormat = "\(sameDay ? "'Today'" : "E,") h:mm a"
    return formatter.string(from: date)
  }
}
