//
//  BackgroundView.swift
//  Weather
//
//  Created by Samuel Shi on 10/24/20.
//

import SwiftUI

struct BackgroundView: View {

  let colors: [Color]

  var body: some View {
    LinearGradient(
      gradient: Gradient(colors: colors),
      startPoint: .top,
      endPoint: .bottom
    )
    .ignoresSafeArea()
  }
}
