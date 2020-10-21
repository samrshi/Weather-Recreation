//
//  HourlyView.swift
//  Weather
//
//  Created by Samuel Shi on 9/28/20.
//

import SwiftUI

struct HourlyView: View {
  
  @EnvironmentObject var weather: WeatherPublisher
  
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        ForEach(weather.response.filteredHourly, id: \.dt) { hour in
          VStack {
            HStack(alignment: .bottom, spacing: 0) {
              Text(hour.formattedHour())
                .fontWeight(hour.formattedHour() == "Now" ? .semibold : .regular)
                .font(.footnote)
              
              Text(hour.formattedPeriod())
                .font(.caption2)
            }
            .fixedSize(horizontal: true, vertical: false)
            
            hour.weather.first?.symbol()
              .renderingMode(.original)
              .font(.system(size: 15))
              .frame(height: 50)
            
            Text("\(Int(hour.temp))º")
              .font(.subheadline)
            
          }
          .padding(.trailing, 6)
        }
      }
    }
  }
}

struct HourlyView_Previews: PreviewProvider {
  static var previews: some View {
    HourlyView()
  }
}
