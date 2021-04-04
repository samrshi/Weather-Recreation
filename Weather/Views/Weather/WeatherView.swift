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
  @ObservedObject var userInfo: UserInfo = UserInfo.shared
  @StateObject private var weather: WeatherPublisher = WeatherPublisher()
  @State private var showSheet: Bool = false
  
  var location: Location? = nil
  @Binding var bgColors: [[Color]]
  let index: Int
  
  let timer = Timer.publish(every: 60*15, on: .main, in: .common).autoconnect()
  @State private var didAppear = false
//  init(location: Location? = nil, bgColors: Binding<[[Color]]>, index: Int) {
//    self.location = location
//    self._bgColors = bgColors
//    self.index = index
//    
//    self._weather = StateObject(wrappedValue: WeatherPublisher())
//    self.fillInLocation()
//  }
  
  var body: some View {
    ZStack {
      VStack {
        HeaderView(showSheet: $showSheet)
        
        ScrollView(.vertical) {
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
          
          MyDivider()
        }
      }
    }
    .if(weather.loadingState == .empty) {
      $0.redacted(reason: .placeholder)
    }
    .foregroundColor(.white)
    .environmentObject(weather)
    .onReceive(timer) { _ in
      weather.getWeather()
    }
    .onChange(of: weather.response) { _ in
      let vm = CurrentViewModel(weather.response, isWidget: false)
      bgColors[index] = vm.getBackgroundColors()
    }
    .sheet(isPresented: $showSheet) {
      SearchView()
    }
    .onAppear {
      if !didAppear {
        fillInLocation()
        didAppear = true
      }
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
    let vm = CurrentViewModel(weather.response, isWidget: false)
    bgColors[index] = vm.getBackgroundColors()
  }
}
