//
//  WidgetLocationManager.swift
//  Weather
//
//  Created by Samuel Shi on 9/29/20.
//

import Foundation
import CoreLocation

// currently unused
class WidgetLocationManager: NSObject, CLLocationManagerDelegate {
  
  static var shared = WidgetLocationManager()
  
  var locationManager: CLLocationManager?
  private var handler: ((CLLocation) -> Void)?
  
  @Published var locationString = "None"
  
  override init() {
    super.init()
    DispatchQueue.main.async {
      self.locationManager = CLLocationManager()
      self.locationManager!.delegate = self
      if self.locationManager!.authorizationStatus == .notDetermined {
        self.locationManager!.requestWhenInUseAuthorization()
      }
    }
  }
  
  func fetchLocation(handler: @escaping (CLLocation) -> Void) {
    self.handler = handler
    self.locationManager!.requestLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    self.handler!(locations.last!)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
  
  func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void ) {
    // Use the last reported location.
    if let lastLocation = self.locationManager?.location {
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
