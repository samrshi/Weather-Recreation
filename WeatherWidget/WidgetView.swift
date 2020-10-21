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
    ZStack {
      Color.black
      
      VStack {
        HStack {
          VStack(alignment: .leading) {
            Text(name)
              .font(.system(size: 15))
              .fontWeight(.bold)
            
            Text("\(Int(weather.current.temp))º")
              .font(.system(size: 35))
              .fontWeight(.light)
          }
          
          Spacer()
          
          VStack(alignment: .trailing, spacing: 2) {
            weather.current.weather.first?.symbol()
              .renderingMode(.original)
              .font(.system(size: 15))
              .padding(.bottom, 7)
            Text(weather.current.weather.first?.description.capitalized ?? "")
            HStack(spacing: 3) {
              Text("H:\(Int(weather.daily.first?.temp.max ?? -1))º")
              Text("L:\(Int(weather.daily.first?.temp.min ?? -1))º")
            }
          }
          .font(.system(size: 12))
        }
        
        Spacer()
                
        HourlyView(weather: weather, max: 5)
      }
      .padding()
    }
    .foregroundColor(.white)
  }
}
