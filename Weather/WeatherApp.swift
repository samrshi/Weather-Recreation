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
  
  var body: some Scene {
    WindowGroup {
      ZStack {
        BackgroundView()
        
        TabView(selection: $currentTab) {
          WeatherView(location: nil)
            .tabItem {
              Image(systemName: "location.fill")
            }
            .tag(0)
          
          ForEach(userInfo.locations.cities, id: \.self) { location in
            WeatherView(location: location)
              .tag(userInfo.locations.cities.firstIndex(of: location)! + 1)
          }
        }
        .tabViewStyle(PageTabViewStyle())
        .id(userInfo.locations.cities.count)
      }
      .environmentObject(userInfo)
      .preferredColorScheme(.dark)
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
    }
  }
}
