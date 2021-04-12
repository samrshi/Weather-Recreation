//
//  WeatherPublisherNew.swift
//  Weather
//
//  Created by Samuel Shi on 4/11/21.
//

import Foundation

class WeatherPublisher: ObservableObject, LocationManagerDelegate {
//  private let apiKey = "6e53cf14bdc33a0553d5c58948097ad2"
  private let apiKey = "819115d2218656ef7a506d449eb0c538"



  @Published var response: OneCallResponse
  @Published var loadingState: LoadingState
  @Published var location: Location {
    didSet { updateUserLocations() }
  }
  
  let locationType: LocationType
  var locationManger: LocationManager? = nil
  var timer: Timer? = nil
  
  init(location: Location?) {
    loadingState = .empty
    response = OneCallResponse.example()
    
    if let location = location {
      self.location     = location
      self.locationType = .specific
      getWeather()
    } else {
      self.location  = Location(name: "Loading", lat: 0, lon: 0)
      locationManger = LocationManager()
      locationType   = .current
      locationManger?.delegate = self
    }
//    timer = Timer.scheduledTimer(withTimeInterval: .fifteenMinutes, repeats: true) { [weak self] timer in
//      self?.getWeather()
//    }
  }
  
  func getWeather() {
    let lat       = location.lat
    let lon       = location.lon
    let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=imperial"
    
    API.fetch(type: OneCallResponse.self, urlString: urlString, decodingStrategy: .convertFromSnakeCase) { result in
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
  
  func updateUserLocations() {
    UserLocations.shared.updateCurrentLocation(location)
  }
  
  /// From locationManager: only called if this publisher is for current location
  /// - Parameter location: current location
  func locationsDidChange(location: Location) {
    self.location = location
    getWeather()
  }
}
