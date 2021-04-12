//
//  View+TabBackground.swift
//  Weather
//
//  Created by Samuel Shi on 4/11/21.
//

import SwiftUI

extension View {
  func tabFullScreenBackground(geo: GeometryProxy, colors: [Color]) -> some View {
    self
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(
        LinearGradient(
          gradient: Gradient(colors: colors),
          startPoint: .top,
          endPoint: .bottom
        ).frame(minHeight: 2 * geo.size.height)
      )
  }
}
