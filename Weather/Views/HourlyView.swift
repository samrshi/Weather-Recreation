//
//  HourlyView.swift
//  Weather
//
//  Created by Samuel Shi on 9/28/20.
//

import SwiftUI

struct HourlyView: View {
  
  let weather: OneCallResponse
  let max: Int?
  
  var body: some View {
    HStack {
      ForEach(weather.filteredHourly(max: max), id: \.dt) { hour in
        VStack {
          HStack(alignment: .bottom, spacing: 0) {
            Text(hour.formattedHour())
              .fontWeight(hour.formattedHour() == "Now" || max != nil ? .semibold : .regular)
              .font(max == nil ? .footnote : .caption2)
            
            Text(hour.formattedPeriod())
              .font(.caption2)
              .fontWeight(max == nil ? .regular : .semibold)
          }
          .if(max != nil) {
            $0.foregroundColor(Color(.lightGray))
          }
          .fixedSize(horizontal: true, vertical: false)
          
          hour.weather.first?.symbol()
            .renderingMode(.original)
            .font(.system(size: 15))
            .frame(height: max == nil ? 50 : 30)
          
          Text("\(Int(hour.temp))º")
            .font(max == nil ? .subheadline : .system(size: 12))
        }
        .padding(.trailing, 6)
        
        if weather.filteredHourly(max: max).firstIndex(where: {
          $0.dt == hour.dt
        }) != 4 {
          Spacer()
        }
      }
    }
  }
}
