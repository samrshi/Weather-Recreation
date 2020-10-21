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
        CurrentView(showSheet: $showSheet)
        
        Divider()
        
        ScrollView(.horizontal, showsIndicators: false) {
          HourlyView(weather: weather.response, max: nil)
            .padding(.leading)
        }
        
        Divider()
        
        DailyView()
        
        Divider()
        
        Spacer()
      }
    }
    .if(weather.loadingState == .empty) {
      $0.redacted(reason: .placeholder)
    }
    .foregroundColor(.white)
    .environmentObject(weather)
    .sheet(isPresented: $showSheet) {
      SearchView()
        .environmentObject(userInfo)
    }
    .onAppear {
      if let location = location {
        weather.locationType = .specific
        weather.locationString = location.name
        weather.latitude = location.lat
        weather.longitude = location.lon
        weather.getWeather()
      }
    }
    .onReceive(timer) { _ in
      weather.getWeather()
    }
  }
}
