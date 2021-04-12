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
  @State private var bgColors: [[Color]] = [[]]
  
  init() {
    let count = userLocations.locations.cities.count + 1
    _bgColors = State(initialValue: [[Color]](repeating: [.clear], count: count))
  }
  
  var body: some Scene {
    WindowGroup {
      GeometryReader { geo in
        TabView(selection: $currentTab) {
          currentWeatherView(geo: geo)
          
          ForEach(userLocations.locations.cities, id: \.self) { location in
            locationWeatherView(location, geo: geo)
          }
        }
        .ignoresSafeArea()
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .id(userLocations.locations.cities.count)
        .preferredColorScheme(.dark)
        .onOpenURL(perform: openURL)
        .onAppear(perform: fillBackgroundDefault)
        .onChange(of: userLocations.locations.cities.count) { [userLocations] new in
          fillBackgroundArray(
            oldLength: userLocations.locations.cities.count,
            newLength: new
          )
        }
      }
    }
  }
  
  func currentWeatherView(geo: GeometryProxy) -> some View {
    WeatherView(
      location: nil,
      bgColors: $bgColors,
      index: 0
    )
    .tabItem {
      Image(systemName: "location.fill")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
      LinearGradient(
        gradient: Gradient(colors: bgColors[0]),
        startPoint: .top,
        endPoint: .bottom
      ).frame(minHeight: 2 * geo.size.height)
    )
    .tag(0)
  }
  
  func locationWeatherView(_ location: Location, geo: GeometryProxy) -> some View {
    WeatherView(
      location: location,
      bgColors: $bgColors,
      index: indexOfLocation(location)
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
      gradientForLocation(location)
        .frame(minHeight: 2 * geo.size.height)
    )
    .tag(indexOfLocation(location))
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
  
  /// Fill Background Colors Array with Default Values
  func fillBackgroundDefault() {
    bgColors = [[Color]](repeating: [.clear], count: userLocations.locations.cities.count + 1)
  }
  
  func fillBackgroundArray(oldLength: Int, newLength: Int) {
    if oldLength < newLength {
      bgColors.append([.clear])
    }
  }
  
  func indexOfLocation(_ location: Location) -> Int {
    (userLocations.locations.cities.firstIndex(of: location) ?? 0) + 1
  }
  
  func gradientForLocation(_ location: Location) -> LinearGradient {
    let index = indexOfLocation(location)
    let colors: [Color]
    
    colors = index >= bgColors.count ? [.clear] : bgColors[index]
    
    return LinearGradient(
      gradient: Gradient(colors: colors),
      startPoint: .top,
      endPoint: .bottom
    )
  }
}

