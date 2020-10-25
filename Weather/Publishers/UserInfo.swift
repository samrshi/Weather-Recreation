//
//  UserInfo.swift
//  Weather
//
//  Created by Samuel Shi on 9/29/20.
//

import Foundation
import WidgetKit

class UserInfo: ObservableObject {
  
  static let shared = UserInfo()
  let citiesKey = "Cities"
  
  @Published var cities: Locations {
    didSet {
      print(cities.current.name)
      save()
    }
  }
  
  init() {
    cities = UserInfo.getFromDefaults(forKey: citiesKey, type: Locations.self) ?? Locations.staticInit()
  }
  
  func save() {
    if let encodedCities = try? JSONEncoder().encode(cities) {
      UserDefaults.standard.set(encodedCities, forKey: citiesKey)
    }
  }
  
  func writeContents() {
    let archiveURL = FileManager.sharedContainerURL()
      .appendingPathComponent("contents.json")
    let encoder = JSONEncoder()
    if let dataToSave = try? encoder.encode(cities) {
      do {
        try dataToSave.write(to: archiveURL)
      } catch {
        print("Error: Can't write contents")
        return
      }
    }
  }
  
  func updateCurrentLocation(_ location: Location) {
    cities.current = location
    writeContents()
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

extension FileManager {
  static func sharedContainerURL() -> URL {
    return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: "group.com.samrshi.Weather.contents"
    )!
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
