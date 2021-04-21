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
    OneCallResponse(
      lat: 40.12,
      lon: -96.66,
      timezone: "America/Chicago",
      timezoneOffset: -18000,
      current: CurrentResponse.example(),
      hourly: [HourlyResponse](repeating: .example(), count: 10),
      daily: [DailyResponse](repeating: .example(), count: 7)
    )
  }
}

extension OneCallResponse: Equatable {
  static func == (lhs: OneCallResponse, rhs: OneCallResponse) -> Bool {
    lhs.current.dt == rhs.current.dt
  }
}
