//
//  HeaderView.swift
//  Weather
//
//  Created by Samuel Shi on 10/24/20.
//

import SwiftUI

struct HeaderView: View {
  @Binding var showSearchSheet: Bool
  let location: Location
  let response: OneCallResponse
  
  var body: some View {
    HStack(alignment: .center) {
      VStack(alignment: .leading) {
        Text(location.name)
          .font(.largeTitle)
        
        Text(response.formattedDate())
          .foregroundColor(.secondary)
      }
      Spacer()
    }
    .padding(.top, 45)
    .padding(.horizontal)
  }
}
