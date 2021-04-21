//
//  Colors.swift
//  Weather
//
//  Created by Samuel Shi on 10/24/20.
//

import SwiftUI

extension Array where Element == Color {
  static var night: [Color] {
    [
      Color("nightTop"),
      Color("nightBottom")
    ]
  }

  static var day: [Color] {
    [
      Color("dayTop"),
      Color("dayBottom")
    ]
  }
}
