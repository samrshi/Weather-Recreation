//
//  CurrentWeatherView.swift
//  Weather
//
//  Created by Samuel Shi on 10/2/20.
//

import SwiftUI

public struct CurrentView: View {

  let current: CurrentViewModel

  public var body: some View {
    VStack {
      Group {
        HStack {
          Image(systemName: current.icon())
            .renderingMode(.original)
            .font(.system(size: 80))
            .frame(height: 100)

          Spacer()

          VStack(alignment: .trailing) {
            Text(current.temperature())
              .fontWeight(.thin)
              .font(.system(size: 75))
            Text(current.feelsLike())
              .foregroundColor(.secondary)
          }
        }
        .padding(.vertical, 75)

        HStack {
          Text(current.high())
          Spacer()
          Text(current.low())
        }
      }
      .padding(.horizontal)

      MyDivider()
    }
  }
}
