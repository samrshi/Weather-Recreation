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
    
    let current = FileManager.readContents().current
    types.append(
        MyType(
        identifier: current.name, displayName: "My Location",
        latitude: current.lat, longitude: current.lon
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
  
  func defaultCity(for intent: LocationIntent) -> MyType? {
    let current = FileManager.readContents().current
    return MyType(
      identifier: current.name, displayName: "My Location",
      latitude: current.lat, longitude: current.lon
    )
  }
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
