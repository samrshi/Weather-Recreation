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
  
  @EnvironmentObject var userInfo: UserInfo
  @StateObject private var weather: WeatherPublisher = WeatherPublisher()
  @State private var showSheet = false
    
  var location: Location? = nil
  
  let timer = Timer.publish(every: 60*15, on: .main, in: .common).autoconnect()
  
  var body: some View {
    ZStack {
      ScrollView(.vertical) {
        HeaderView(showSheet: $showSheet)

        CurrentView(current: CurrentViewModel(weather.response))
        
        Divider()
        
        ScrollView(.horizontal, showsIndicators: false) {
          HourlyView(hourly: HourlyViewModel(weather.response, isWidget: false))
            .padding(.leading)
        }
        
        Divider()
        
        DailyView(daily: DailyViewModel(weather: weather.response))
        
        Divider()
        
        Spacer()
      }
    }
    .if(weather.loadingState == .empty) {
      $0.redacted(reason: .placeholder)
    }
    .foregroundColor(.white)
    .environmentObject(weather)
    .onAppear(perform: fillInLocation)
    .onReceive(timer) { _ in
      weather.getWeather()
    }
    .sheet(isPresented: $showSheet) {
      SearchView()
        .environmentObject(userInfo)
    }
  }
  
  func fillInLocation() {
    if let location = location {
      weather.locationType = .specific
      weather.locationString = location.name
      weather.latitude = location.lat
      weather.longitude = location.lon
      weather.getWeather()
    }
  }
}
