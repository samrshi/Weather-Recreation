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
      ZStack {
        BackgroundView(colors: bgColors[currentTab])
        
        TabView(selection: $currentTab) {
          WeatherView(location: nil, bgColors: $bgColors, index: 0)
            .tabItem {
              Image(systemName: "location.fill")
            }
            .tag(0)
          
          ForEach(userInfo.locations.cities, id: \.self) { location in
            WeatherView(
              location: location,
              bgColors: $bgColors,
              index: (userInfo.locations.cities.firstIndex(of: location) ?? 0) + 1
            )
            .tag((userInfo.locations.cities.firstIndex(of: location) ?? 0) + 1)
          }
        }
        .tabViewStyle(PageTabViewStyle())
        .id(userInfo.locations.cities.count)
        .preferredColorScheme(.dark)
      }
      .environmentObject(userInfo)
      .onOpenURL { url in
        if url.absoluteString == "widget://Current" {
          currentTab = 0
          return
        }
        
        for i in 0..<userInfo.locations.cities.count {
          let name = userInfo.locations.cities[i].name
          let link = "widget://\(name)"
          if link == url.absoluteString {
            currentTab = i + 1
            return
          }
        }
      }
      .onAppear {
        bgColors = [[Color]](repeating: .night, count: userInfo.locations.cities.count + 1)
      }
      .onChange(of: userInfo.locations.cities.count) { _ in
        bgColors = [[Color]](repeating: .night, count: userInfo.locations.cities.count + 1)
      }
    }
  }
}
