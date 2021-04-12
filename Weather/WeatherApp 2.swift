//
//  WeatherApp.swift
//  Weather
//
//  Created by Samuel Shi on 9/28/20.
//

import SwiftUI

@main
struct WeatherApp: App {
  @ObservedObject var userLocations: UserLocations = UserLocations.shared
  @State private var currentTab = 0
  
  var body: some Scene {
    let binding = Binding(
      get: {
        [WeatherVC(location: nil)]
        + userLocations.locations.cities.map { WeatherVC(location: $0) }
      },
      set: { _, _ in }
    )
    
    return WindowGroup {
      PageViewController(pages: binding, currentPage: $currentTab)
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
        .onOpenURL(perform: openURL)
    }
  }
  
  func openURL(url: URL) {
    if url.absoluteString == "widget://Current" {
      currentTab = 0
      return
    }
    
    for i in 0..<userLocations.locations.cities.count {
      let name = userLocations.locations.cities[i].name.spacesToPluses()
      let link = "widget://\(name)"
      if link == url.absoluteString {
        currentTab = i + 1
        return
      }
    }
  }
}

