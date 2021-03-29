//
//  WeatherApp.swift
//  Weather
//
//  Created by Samuel Shi on 9/28/20.
//

import SwiftUI

@main
struct WeatherApp: App {
  @StateObject var userInfo: UserInfo = UserInfo.shared
  
  @State private var currentTab = 0
  @State private var bgColors: [[Color]] = [.night]
  
  var body: some Scene {
    WindowGroup {
      GeometryReader { geo in
        TabView(selection: $currentTab) {
          Group {
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
            
            ForEach(userInfo.locations.cities, id: \.self) { location in
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
          }
        }
        .ignoresSafeArea()
        //      .background(
        //        BackgroundView(colors: bgColors[currentTab])
        //      )
        .tabViewStyle(
          PageTabViewStyle(indexDisplayMode: .always)
        )
        .id(userInfo.locations.cities.count)
        .preferredColorScheme(.dark)
        .environmentObject(userInfo)
        .onOpenURL(perform: openURL)
        .onAppear(perform: fillBackgroundArray)
        .onChange(of: userInfo.locations.cities.count, perform: fillBackgroundArray)
      }
    }
  }
  
  func openURL(url: URL) {
    if url.absoluteString == "widget://Current" {
      currentTab = 0
      return
    }
    
    for i in 0..<userInfo.locations.cities.count {
      let name = userInfo.locations.cities[i].name.spacesToPluses()
      let link = "widget://\(name)"
      if link == url.absoluteString {
        currentTab = i + 1
        return
      }
    }
  }
  
  /// Fill Background Colors Array with Default Values
  func fillBackgroundArray() {
    bgColors = [[Color]](repeating: .night, count: userInfo.locations.cities.count + 1)
  }
  
  func fillBackgroundArray<T: Equatable>(_: T) {
    fillBackgroundArray()
  }
  
  func indexOfLocation(_ location: Location) -> Int {
    (userInfo.locations.cities.firstIndex(of: location) ?? 0) + 1
  }
  
  func gradientForLocation(_ location: Location) -> LinearGradient {
    let index = indexOfLocation(location)
    let colors: [Color]
    
    colors = index >= bgColors.count ? .night : bgColors[index]
    
    return LinearGradient(
      gradient: Gradient(colors: colors),
      startPoint: .top,
      endPoint: .bottom
    )
  }
}

