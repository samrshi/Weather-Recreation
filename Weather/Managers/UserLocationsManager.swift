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
  let citiesKey = "locations"

  @Published var locations: [Location] {
    didSet { updateCurrentLocation() }
  }

  init() {
    locations = FileManager.readCitiesFromDisk() ?? []
  }

  func updateCurrentLocation() {
    FileManager.writeCitiesToDisk(locations: locations)
    WidgetCenter.shared.reloadAllTimelines()
  }
}

struct Location: Codable, Hashable {
  let name: String

  let lat: Double
  let lon: Double
}
