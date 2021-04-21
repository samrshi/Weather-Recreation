//
//  ContentView.swift
//  Weather
//
//  Created by Samuel Shi on 9/28/20.
//

import SwiftUI
import MapKit

struct WeatherView: View {
  @ObservedObject var weather: WeatherDataManager
  let id: String

  var body: some View {
    VStack {
      HeaderView(location: weather.location.name, current: weather.current())

      ScrollView(.vertical, showsIndicators: false) {
        CurrentView(current: weather.current())

        ScrollView(.horizontal, showsIndicators: false) {
          HourlyView(hourly: weather.hourly())
            .padding(.leading)
        }

        DailyView(daily: weather.daily())

        Overview(overview: weather.overview())
      }

      FooterView()
    }
    .if(weather.loadingState == .empty) { $0.redacted(reason: .placeholder) }
    .frame(width: screen.width, height: screen.height)
    .onAppear(perform: setBackground)
    .onChange(of: weather.response) { _ in setBackground() }
  }

  var screen: CGRect {
    UIScreen.main.bounds
  }

  func setBackground() {
    let name = NSNotification.Name(id)
    NotificationCenter.default.post(Notification(name: name))
  }
}
