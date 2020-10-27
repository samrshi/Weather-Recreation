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
  let isCurrent: Bool
  let weatherVM: WidgetViewModel
  
  var body: some View {
    ZStack {
      BackgroundView(colors: weatherVM.current.getBackgroundColors())
      
      VStack {
        HStack {
          VStack(alignment: .leading) {
            HStack(spacing: 4) {
              Text(name)
                .font(.subheadline)
                .fontWeight(.semibold)
              if isCurrent {
                Image(systemName: "location.fill")
                  .font(.system(size: 10))
              }
            }
            
            Text(weatherVM.current.temperature())
              .fontWeight(.light)
              .scaledFont(size: 37)
          }
          
          Spacer()
          
          VStack(alignment: .trailing, spacing: 2) {
            Image(weatherVM.current.icon())
              .renderingMode(.original)
              .font(.system(size: 15))
              .padding(.bottom, 7)
            Text(weatherVM.current.description())
            HStack(spacing: 3) {
              Text(weatherVM.current.high())
              Text(weatherVM.current.high())
            }
          }
          .font(.system(size: 12))
        }
        
        Spacer()
        
        HourlyView(hourly: weatherVM.hourly)
      }
      .padding(12)
    }
    .widgetURL(URL(string: "widget://\(isCurrent ? "Current" : name)")!)
    .foregroundColor(.white)
  }
}
