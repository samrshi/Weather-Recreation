//
//  UserLocationsManager.swift
//  Weather
//
//  Created by Samuel Shi on 9/29/20.
//

import Foundation
import WidgetKit

class UserLocationsManager: ObservableObject {
  
  static let shared = UserLocationsManager()
  let citiesKey = "Cities"
  
  @Published var locations: [Location] {
    didSet {
      updateCurrentLocation()
    }
  }
  
  init() {
    locations = UserLocationsManager.getFromDefaults(
      forKey: citiesKey, type: [Location].self
    ) ?? []
  }
  
  func save() {
    if let encodedCities = try? JSONEncoder().encode(locations) {
      UserDefaults.standard.set(encodedCities, forKey: citiesKey)
    }
  }
  
  func updateCurrentLocation() {
    FileManager.writeContents(locations: locations)
    WidgetCenter.shared.reloadAllTimelines()
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


//struct Locations: Codable {
//  var current: Location
//  var cities: [Location]
//  
//  static func staticInit() -> Locations {
//    Locations(current: Location.staticInit(), cities: [])
//  }
//}

struct Location: Codable, Hashable {
  let name: String
  
  let lat: Double
  let lon: Double
  
  static func staticInit() -> Location {
    Location(name: "Empty", lat: 0, lon: 0)
  }
}
