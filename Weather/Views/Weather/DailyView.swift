//
//  DailyView.swift
//  Weather
//
//  Created by Samuel Shi on 9/28/20.
//

import SwiftUI

struct DailyView: View {
  
  let daily: DailyViewModel
  
  var body: some View {
    ForEach(daily.days(), id: \.dt) { day in
      HStack {
        Text(daily.weekday(for: day))
          .scaledFont(size: 20)
          .frame(width: 120, alignment: .leading)
        
        Spacer()
        
        Image(systemName: daily.icon(for: day))
          .renderingMode(.original)
          .font(.headline)
          .frame(width: 20)
        
        Text(daily.precipitation(for: day))
          .bold()
          .foregroundColor(Color("ChanceOfRain"))
          .font(.caption)
          .frame(width: 50)
        
        Spacer()
        
        Text(daily.high(for: day))
          .font(.headline)
          .frame(width: 30, alignment: .trailing)
        
        Text(daily.low(for: day))
          .font(.headline)
          .frame(width: 30, alignment: .trailing)
          .foregroundColor(.secondary)
      }
      .font(.subheadline)
    }
    .padding(.horizontal)
    .padding(.bottom, 3)
  }
}
