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
  @State private var count = 3
  
  var body: some Scene {
    WindowGroup {
      ZStack {
        Color.black
          .ignoresSafeArea(.all, edges: .all)
        
        TabView {
          WeatherView(location: nil)
            .tabItem( {
              Image(systemName: "location.fill")
            })
          
          ForEach(userInfo.cities.cities, id: \.self) { location in
            WeatherView(location: location)
          }
        }
        .tabViewStyle(PageTabViewStyle())
        .id(userInfo.cities.cities.count)
      }
      .environmentObject(userInfo)
      .preferredColorScheme(.dark)
    }
  }
}
