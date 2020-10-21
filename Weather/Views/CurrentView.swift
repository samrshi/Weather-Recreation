//
//  CurrentWeatherView.swift
//  Weather
//
//  Created by Samuel Shi on 10/2/20.
//

import SwiftUI

public struct CurrentView: View {
  @Binding var showSheet: Bool
  @EnvironmentObject var weather: WeatherPublisher
  
  public var body: some View {
    VStack {
      HStack {
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
        }
      }
      .padding(.top)
      
      
      HStack {
        weather.response.current.weather.first?.symbol()
          .renderingMode(.original)
          .font(.system(size: 80))
          .frame(height: 100)
        
        Spacer()
        
        VStack(alignment: .trailing) {
          Text("\(Int(weather.response.current.temp))ºF")
            .fontWeight(.thin)
            .font(.system(size: 75))
          
          Text("Feels Like \(Int(weather.response.current.feelsLike))ºF")
            .foregroundColor(.gray)
        }
      }
      .padding(.vertical, 50)
      
      HStack {
        Text("High: \(weather.response.daily.first?.temp.max ?? -1, specifier: "%.0f")º")
        
        Spacer()
        
        Text("Low: \(weather.response.daily.first?.temp.min ?? -1, specifier: "%.0f")º")
      }
    }
    .padding(.horizontal)
  }
}
