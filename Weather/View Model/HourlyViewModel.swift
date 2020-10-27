//
//  HourlyViewModel.swift
//  Weather
//
//  Created by Samuel Shi on 10/24/20.
//

import SwiftUI

struct HourlyViewModel {
  
  let weather: OneCallResponse
  let isWidget: Bool
  
  init(_ response: OneCallResponse, isWidget: Bool) {
    weather = response
    self.isWidget = isWidget
  }
  
  func hours() -> [HourlyResponse] {
    var filtered = weather.hourly.filter { hour in
      let date = Date(timeIntervalSince1970: TimeInterval(hour.dt))
      let endDate = Date(timeIntervalSinceNow: 60*60*24)
      return date <= endDate
    }
    
    if isWidget {
      filtered.removeFirst()
      return Array(filtered.prefix(6))
    }
    return filtered
  }
  
  func time(for hour: HourlyResponse) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h"
    let date = Date(timeIntervalSince1970: TimeInterval(hour.dt))
    let isNow = Calendar.current.isDate(Date(), equalTo: date, toGranularity: .hour)
    
    return isNow ? "Now" : formatter.string(from: date)
  }
  
  func period(for hour: HourlyResponse) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "a"
    let date = Date(timeIntervalSince1970: TimeInterval(hour.dt))
    
    return Calendar.current.isDate(Date(), equalTo: date, toGranularity: .hour) ? "" : formatter.string(from: date)
  }
  
  func icon(for hour: HourlyResponse) -> String {
    hour.weather.first?.icon.symbol() ?? "photo"
  }
  
  func temp(for hour: HourlyResponse) -> String {
    "\(Int(hour.temp))º"
  }
  
  func weight(for hour: HourlyResponse) -> Font.Weight {
    time(for: hour) == "Now" ? .semibold : .regular
  }
  
  func precipitation(for hour: HourlyResponse) -> String {
    hour.pop == 0 ? "" : "\(Int(hour.pop * 100))%"
  }
}
