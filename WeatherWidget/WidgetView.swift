//
//  WidgetView.swift
//  Weather
//
//  Created by Samuel Shi on 9/29/20.
//

import SwiftUI
import WidgetKit

struct WidgetView: View {
  
  let name: String
  let weather: OneCallResponse
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(name)
          .font(.caption)
          .bold()
        
        Spacer()
      }
      
      Text("\(weather.current.temp)ºF")
      
      Spacer()
    }
    .padding()
  }
}
