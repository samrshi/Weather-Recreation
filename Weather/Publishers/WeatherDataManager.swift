//
//  WeatherDataManager.swift
//  Weather
//
//  Created by Samuel Shi on 4/11/21.
//

import Foundation

enum LoadingState {
  case empty
  case filled
}

enum LocationType {
  case current
  case specific
}

let apiKey = "819115d2218656ef7a506d449eb0c538"

class WeatherDataManager: ObservableObject, LocationManagerDelegate {

  @Published var response: OneCallResponse
  @Published var loadingState: LoadingState
  @Published var location: Location
  
  let locationType: LocationType
  var locationManger: LocationManager? = nil
  var timer: Timer? = nil
  
  init(location: Location?) {
    loadingState = .empty
    response = OneCallResponse.example()
    
    if let location = location {
      self.locationType = .specific
      self.location     = location
      getWeather()
    } else {
      locationType   = .current
      self.location  = Location(name: "Loading", lat: 0, lon: 0)
      locationManger = LocationManager()
      locationManger?.delegate = self
    }
    
    timer = Timer.scheduledTimer(withTimeInterval: .fifteenMinutes, repeats: true) { [weak self] timer in
      self?.getWeather()
    }
  }
  
  func getWeather() {
    let lat       = location.lat
    let lon       = location.lon
    let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=imperial"
    
    Network.fetch(type: OneCallResponse.self, urlString: urlString, decodingStrategy: .convertFromSnakeCase) { result in
      switch result {
      case .success(let response):
        self.response = response
        self.loadingState = .filled
      case .failure(let error):
        // handle error
        print(error.localizedDescription)
      }
    }
  }
  
  /// From locationManager: only called if this manager is for current location
  /// - Parameter location: current location
  func locationsDidChange(location: Location) {
//    print("new location")
    self.location = location
    getWeather()
  }
}
