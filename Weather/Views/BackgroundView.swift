//
//  BackgroundView.swift
//  Weather
//
//  Created by Samuel Shi on 10/24/20.
//

import SwiftUI

struct BackgroundView: View {
    
  var body: some View {
    LinearGradient(
      gradient: Gradient(colors: .night),
      startPoint: .top,
      endPoint: .bottom
    )
    .ignoresSafeArea()
  }
}
