//
//  WeatherApp.swift
//  Weather
//
//  Created by Samuel Shi on 9/28/20.
//

import SwiftUI

@main
struct WeatherApp: App {
  @ObservedObject var userLocationsManager = UserLocationsManager.shared
  @State private var currentTab = 0
  @State private var showSearchSheet = false

  var locations: [WeatherVC] {
    [WeatherVC(location: nil)] + userLocationsManager.locations.map { WeatherVC(location: $0) }
  }

  var body: some Scene {
    WindowGroup {
      PageVC(
        pages: locations,
        currentPage: $currentTab,
        showSearchSheet: $showSearchSheet
      )
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

    for (index, location) in userLocationsManager.locations.enumerated() {
      let name = location.name.spacesToPluses()
      let link = "widget://\(name)"
      if link == url.absoluteString {
        currentTab = index + 1
        return
      }
    }
  }
}
