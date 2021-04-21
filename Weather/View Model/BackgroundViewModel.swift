//
//  BackgroundViewModel.swift
//  Weather
//
//  Created by Samuel Shi on 10/24/20.
//

import SwiftUI

struct BackgroundViewModel {
  let icon: String

  func colors() -> [Color] {
    switch icon.last {
    case "d":
      return .day
    case "n":
      return .night
    default:
      return .night
    }
  }
}
