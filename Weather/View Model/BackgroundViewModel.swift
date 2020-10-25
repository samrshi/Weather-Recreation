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
      return Color.day
    case "n":
      return Color.night
    default:
      return Color.night
    }
  }
}
