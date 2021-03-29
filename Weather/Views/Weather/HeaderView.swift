//
//  HeaderView.swift
//  Weather
//
//  Created by Samuel Shi on 10/24/20.
//

import SwiftUI

struct HeaderView: View {
  
  @EnvironmentObject var weather: WeatherPublisher
  @Binding var showSheet: Bool
  
  var body: some View {
    HStack(alignment: .top) {
      VStack(alignment: .leading) {
        Text("\(weather.locationString)")
          .font(.largeTitle)
        
        Text(weather.response.formattedDate())
          .foregroundColor(.secondary)
      }
      
      Spacer()
      
      Button(action: {
        showSheet.toggle()
      }) {
        Image(systemName: "magnifyingglass")
          .foregroundColor(.white)
          .font(.system(size: 20))
      }
    }
    .padding([.top, .horizontal])
  }
}
