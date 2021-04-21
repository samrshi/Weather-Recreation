//
//  WeatherModel.swift
//  Weather
//
//  Created by Samuel Shi on 10/14/20.
//

import Foundation
import SwiftUI

struct Weather: Codable {
  var id: Int
  var main: String
  var description: String
  var icon: String

  static func example() -> Weather {
    Weather(id: 501, main: "Rain", description: "moderate rain", icon: "10n")
  }
}
