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
  @State private var showSearchSheet = false
  
  var locations: [WeatherVC] {
    [WeatherVC(location: nil)] + userLocations.locations.cities.map { WeatherVC(location: $0) }
  }
  
  var body: some Scene {
    WindowGroup {
      PageViewController(pages: locations, currentPage: $currentTab, showSearchSheet: $showSearchSheet)
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
        .onOpenURL(perform: openURL)
        .sheet(isPresented: $showSearchSheet) { SearchView() }
      }
    }
  
  func openURL(url: URL) {
    if url.absoluteString == "widget://Current" {
      currentTab = 0
      return
    }
    
    for (index, location) in userLocations.locations.cities.enumerated() {
      let name = location.name.spacesToPluses()
      let link = "widget://\(name)"
      if link == url.absoluteString {
        currentTab = index + 1
        return
      }
    }
  }
}

