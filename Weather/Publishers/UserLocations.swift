//
//  UserLocations.swift
//  Weather
//
//  Created by Samuel Shi on 9/29/20.
//

import Foundation
import WidgetKit

class UserLocations: ObservableObject {
  
  static let shared = UserLocations()
  let citiesKey = "Cities"
  
  @Published var locations: Locations {
    didSet {
      save()
    }
  }
  
  init() {
    locations = UserLocations.getFromDefaults(forKey: citiesKey, type: Locations.self) ?? Locations.staticInit()
  }
  
  func save() {
    if let encodedCities = try? JSONEncoder().encode(locations) {
      UserDefaults.standard.set(encodedCities, forKey: citiesKey)
    }
  }
  
  func updateCurrentLocation(_ location: Location) {
    locations.current = location
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


struct Locations: Codable {
  var current: Location
  var cities: [Location]
  
  static func staticInit() -> Locations {
    Locations(current: Location.staticInit(), cities: [])
  }
}

struct Location: Codable, Hashable {
  let name: String
  
  let lat: Double
  let lon: Double
  
  static func staticInit() -> Location {
    Location(name: "Empty", lat: 0, lon: 0)
  }
}
