//
//  ContentView.swift
//  Weather
//
//  Created by Samuel Shi on 9/28/20.
//

import SwiftUI
import MapKit

enum WeatherType {
  case current
  case specific
}

struct WeatherView: View {
  @ObservedObject var weather: WeatherPublisher
  let id: String

  @State private var showSearchSheet = false
  @State private var background: [Color] = [.clear]
  
  init(weather: WeatherPublisher, id: String) {
    self.weather = weather
    self.id = id
    
    print("init weather view")
  }
  
  var body: some View {
    VStack {
      HeaderView(showSearchSheet: $showSearchSheet, location: weather.location, response: weather.response)
      
      ScrollView(.vertical, showsIndicators: false) {
        CurrentView(current: CurrentViewModel(weather.response, isWidget: false))
        
        MyDivider()
        
        ScrollView(.horizontal, showsIndicators: false) {
          HourlyView(hourly: HourlyViewModel(weather.response, isWidget: false))
            .padding(.leading)
        }
        
        MyDivider()
        
        DailyView(daily: DailyViewModel(weather: weather.response))
        
        MyDivider()
        
        Overview(overview: OverviewViewModel(weather: weather.response))
      }
      
      MyDivider().offset(y: -8)
      Color.clear
        .frame(height: 65)
    }
    .frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height)
    .if(weather.loadingState == .empty) { $0.redacted(reason: .placeholder) }
    .navigationViewStyle(StackNavigationViewStyle())
    .onAppear(perform: setBackground)
    .onChange(of: weather.response) { _ in setBackground() }
    .foregroundColor(.white)
  }
  
  func setBackground() {
    background = CurrentViewModel(weather.response, isWidget: false)
      .getBackgroundColors()
    
    let name = NSNotification.Name(id)
    NotificationCenter.default.post(Notification(name: name))
  }
}
