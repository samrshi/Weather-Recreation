//
//  ConditionalModifier.swift
//  Weather
//
//  Created by Samuel Shi on 9/29/20.
//

import SwiftUI

extension View {
  func `if`<T: View>(_ condition: Bool, apply: (Self) -> T) -> some View {
    if condition {
      return AnyView(apply(self))
    } else {
      return AnyView(self)
    }
  }
}
