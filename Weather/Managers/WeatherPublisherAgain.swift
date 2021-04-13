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

let apiKey = "00858e474ad1b9d21d540d0cd9cc718e"

class WeatherPublisherAgain: NSObject, ObservableObject {
  
  @Published var response: OneCallResponse
  @Published var location: Location
  @Published var loadingState: LoadingState = .empty
  
  private let locationManager = CLLocationManager()
  private var oldLocation: CLLocation? = nil

  
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
  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
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
  
  func updateUserLocations() {
    UserLocations.shared.updateCurrentLocation(Location(name: locationString, lat: latitude, lon: longitude))
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
