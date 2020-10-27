//
//  DailyViewModel.swift
//  Weather
//
//  Created by Samuel Shi on 10/24/20.
//

import SwiftUI

struct DailyViewModel {
  
  let weather: OneCallResponse
  
  func days() -> [DailyResponse] {
    return weather.daily.filter { day in
      let date = Date(timeIntervalSince1970: TimeInterval(day.dt))
      return !Calendar.current.isDateInToday(date)
    }
  }
  
  func weekday(for day: DailyResponse) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE"
    let date = Date(timeIntervalSince1970: TimeInterval(day.dt))
    return formatter.string(from: date)
  }
  
  func icon(for day: DailyResponse) -> String {
    day.weather.first?.icon.symbol() ?? "photo"
  }
  
  func precipitation(for day: DailyResponse) -> String {
    day.pop == 0 ? "" : "\(Int(day.pop * 100))%"
  }
  
  func high(for day: DailyResponse) -> String {
    "\(Int(day.temp.max))"
  }
  
  func low(for day: DailyResponse) -> String {
    "\(Int(day.temp.min))"
  }
}
