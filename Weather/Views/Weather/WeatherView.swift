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
  @State private var showSheet: Bool = false
  @State private var background: [Color] = [.clear]
  
  init(weather: WeatherPublisher) {
    self.weather = weather
    
    print("init weather view")
  }
  
  var body: some View {
    ZStack {
      VStack {
        HeaderView(showSheet: $showSheet, location: weather.location, response: weather.response)

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

          MyDivider()
        }
      }
    }
    .if(weather.loadingState == .empty) { $0.redacted(reason: .placeholder) }
    .onAppear(perform: setBackground)
    .onChange(of: weather.response) { _ in setBackground() }
    .background(BackgroundView(colors: background))
    .foregroundColor(.white)
    .sheet(isPresented: $showSheet) { SearchView() }
  }
  
  func setBackground() {
    background = CurrentViewModel(weather.response, isWidget: false)
      .getBackgroundColors()
  }
}
