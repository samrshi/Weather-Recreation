//
//  HeaderView.swift
//  Weather
//
//  Created by Samuel Shi on 10/24/20.
//

import SwiftUI

struct HeaderView: View {
  let location: String
  let current: CurrentViewModel

  var body: some View {
    HStack(alignment: .center) {
      VStack(alignment: .leading) {
        Text(location)
          .font(.largeTitle)

        Text(current.formattedDate())
          .foregroundColor(.secondary)
      }
      Spacer()
    }
    .padding(.top, 45)
    .padding(.horizontal)
  }
}
