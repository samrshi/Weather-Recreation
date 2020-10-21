//
//  DailyView.swift
//  Weather
//
//  Created by Samuel Shi on 9/28/20.
//

import SwiftUI

struct DailyView: View {
  
  @EnvironmentObject var weather: WeatherPublisher
  
  var body: some View {
    ForEach(weather.response.filteredDaily, id: \.dt) { day in
      HStack {
        Text(day.weekday())
          .frame(width: 100, alignment: .leading)
        
        Spacer()
        
        day.weather.first?.symbol()
          .renderingMode(.original)
          .font(.system(size: 15))
          .frame(width: 20)
        
        Text(day.formattedPop())
          .foregroundColor(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)))
          .font(.caption)
          .frame(width: 35)
        
        Spacer()
        
        Text("\(Int(day.temp.max))")
          .frame(width: 30, alignment: .trailing)
        
        Text("\(Int(day.temp.min))")
          .frame(width: 30, alignment: .trailing)
          .foregroundColor(.gray)
      }
      .font(.subheadline)
    }
    .padding(.horizontal)
    .padding(.bottom, 3)
  }
}

struct DailyView_Previews: PreviewProvider {
  static var previews: some View {
    DailyView()
  }
}
