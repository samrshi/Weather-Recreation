//
//  IntentHandler.swift
//  WeatherIntentHandler
//
//  Created by Samuel Shi on 10/24/20.
//

import Intents

class IntentHandler: INExtension, LocationIntentHandling {
  func provideCityOptionsCollection(
    for intent: LocationIntent,
    with completion: @escaping (INObjectCollection<WidgetLocation>?, Error?) -> Void
  ) {
    let cities = FileManager.readCitiesFromDisk() ?? []
    var options = [WidgetLocation]()

    let current = WidgetLocation(
      identifier: "", displayName: .myLocation,
      latitude: 0, longitude: 0
    )
    options.append(current)

    for city in cities {
      let specificCity = WidgetLocation(
        identifier: city.name, displayName: city.name,
        latitude: city.lat, longitude: city.lon
      )
      options.append(specificCity)
    }

    let collection = INObjectCollection(items: options)
    completion(collection, nil)
  }

  func defaultCity(for intent: LocationIntent) -> WidgetLocation? {
    WidgetLocation(
      identifier: "", displayName: .myLocation,
      latitude: 0, longitude: 0
    )
  }
}

extension String {
  static let myLocation = "My Location"
}

extension WidgetLocation {
  convenience init(
    identifier: String, displayName: String,
    latitude: Double, longitude: Double
  ) {
    self.init(identifier: identifier, display: displayName)
    self.latitude = NSNumber(value: latitude)
    self.longitude = NSNumber(value: longitude)
  }
}
