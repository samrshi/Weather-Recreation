//
//  IntentHandler.swift
//  WeatherIntentHandler
//
//  Created by Samuel Shi on 10/24/20.
//

import Intents

class IntentHandler: INExtension, LocationIntentHandling {
  func provideCityOptionsCollection(for intent: LocationIntent, with completion: @escaping (INObjectCollection<MyType>?, Error?) -> Void) {
    let contents = FileManager.readContents()
    var types = [MyType]()
    
//    let current = contents.current
    types.append(
        MyType(
          identifier: "", displayName: .myLocation,
        latitude: 0, longitude: 0
      )
    )
    
    for city in contents.cities {
      types.append(
        MyType(
          identifier: city.name, displayName: city.name,
          latitude: city.lat, longitude: city.lon
        )
      )
    }
    let collection = INObjectCollection(items: types)
    completion(collection, nil)
  }
}

extension String {
  static let myLocation = "My Location"
}

extension MyType {
  convenience init(
    identifier: String, displayName: String,
    latitude: Double, longitude: Double
  ) {
    self.init(identifier: identifier, display: displayName)
    self.latitude = NSNumber(value: latitude)
    self.longitude = NSNumber(value: longitude)
  }
}
