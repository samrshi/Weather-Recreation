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
  
  var current: GeneralResponse
  var hourly: [GeneralResponse]
  var daily: [DailyResponse]
}

extension OneCallResponse {
  func formattedDate() -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(current.dt))
    let sameDay = Calendar.current.isDate(date, equalTo: Date(), toGranularity: .day)
    let formatter = DateFormatter()
    
    formatter.dateFormat = "\(sameDay ? "'Today'" : "E,") h:mm a"
    return formatter.string(from: date)
  }
  
  func filteredHourly(max: Int?) -> [GeneralResponse] {
    var filtered = hourly.filter { hour in
      let date = Date(timeIntervalSince1970: TimeInterval(hour.dt))
      let endDate = Date(timeIntervalSinceNow: 60*60*24)
      return date <= endDate
    }
    
    if let max = max {
      filtered.removeFirst()
      return Array(filtered.prefix(max))
    }
    return filtered
  }
  
  var filteredDaily: [DailyResponse] {
    return daily.filter { day in
      let date = Date(timeIntervalSince1970: TimeInterval(day.dt))
      return !Calendar.current.isDateInToday(date)
    }
  }
  
  static func blankInit() -> OneCallResponse {
    OneCallResponse(lat: 40.12, lon: -96.66, timezone: "America/Chicago", timezoneOffset: -18000, current: GeneralResponse.blankInit(), hourly: [GeneralResponse.blankInit()], daily: [DailyResponse.blankInit()])
  }
}
