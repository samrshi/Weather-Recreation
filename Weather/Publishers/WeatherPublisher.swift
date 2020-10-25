//
//  LocationManager.swift
//  Weather
//
//  Created by Samuel Shi on 9/28/20.
//

import Foundation
import CoreLocation
import SwiftUI

enum LoadingState {
  case empty
  case filled
}

enum LocationType {
  case current
  case specific
}

let apiKey = "6e53cf14bdc33a0553d5c58948097ad2"
let responseKey = "OneCallResponse"

class WeatherPublisher: NSObject, ObservableObject {
  
  @Published var response: OneCallResponse {
    didSet {
      save()
    }
  }
  
  @Published var locationString: String = "" {
    didSet {
      updateUserInfo()
    }
  }
  @Published var loadingState: LoadingState = .empty
  @Published var locationType: LocationType = .current
  
  @Published var userInfo = UserInfo.shared
  
  var latitude: Double = 0
  var longitude: Double = 0
  
  private let locationManager = CLLocationManager()
  private var oldLocation: CLLocation? = nil
    
  override init() {
    if let fromDefaults =  WeatherPublisher.getFromDefaults(forKey: responseKey, type: OneCallResponse.self) {
      response = fromDefaults
      loadingState = .filled
    } else {
      response = OneCallResponse.example()
      loadingState = .empty
    }
    
    super.init()
    self.locationManager.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.startUpdatingLocation()
    
    getWeather()
  }
  
  func getWeather() {
    let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=imperial"
    
    API.fetch(type: OneCallResponse.self, urlString: urlString, decodingStrategy: .convertFromSnakeCase) { result in
      switch result {
      case .success(let response):
        self.response = response
        self.loadingState = .filled
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
//    updateUserInfo()
  }
  
  func save() {
    if let encodedResponse = try? JSONEncoder().encode(response) {
      UserDefaults.standard.set(encodedResponse, forKey: responseKey)
    }
  }
  
  static func getFromDefaults<T: Decodable>(forKey: String, type: T.Type) -> T? {
    if let data = UserDefaults.standard.data(forKey: forKey) {
      if let decoded = try? JSONDecoder().decode(T.self, from: data) {
        return decoded
      }
    }
    return nil
  }
}

extension WeatherPublisher: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard locationType == .current else {
      return
    }
    
    guard let location = locations.last else { return }
    latitude = location.coordinate.latitude
    longitude = location.coordinate.longitude
    
    if locationManager.authorizationStatus != .denied {
      guard let oldLocation = oldLocation else {
        self.oldLocation = location
        updateLocationString()
        getWeather()
        return
      }
      
      if location.distance(from: oldLocation) > 1000 {
        updateLocationString()
        getWeather()
        print("location change")
        self.oldLocation = location
      }
    }
  }
  
  func updateLocationString() {
    lookUpCurrentLocation { placemark in
      if let placemark = placemark {
        self.locationString = placemark.locality!
      }
    }
  }
  
  func updateUserInfo() {
    userInfo.updateCurrentLocation(Location(name: locationString, lat: latitude, lon: longitude))
  }
  
  func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void ) {
    if locationType == .current {
      // Use the last reported location.
      if let lastLocation = self.locationManager.location {
        let geocoder = CLGeocoder()
        
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
          if error == nil {
            let firstLocation = placemarks?[0]
            completionHandler(firstLocation)
          }
          else {
            // An error occurred during geocoding.
            completionHandler(nil)
          }
        })
      } else {
        // No location was available.
        completionHandler(nil)
      }
    }
  }
}
