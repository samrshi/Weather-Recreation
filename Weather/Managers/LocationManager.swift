//
//  LocationManager.swift
//  Weather
//
//  Created by Samuel Shi on 4/11/21.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate {
  func locationsDidChange(location: Location) -> Void
}

class LocationManager: NSObject, CLLocationManagerDelegate {
  private let locationManager = CLLocationManager()
  var oldLocation: CLLocation? = nil
  
  var delegate: LocationManagerDelegate? = nil
  
  override init() {
    super.init()
    self.locationManager.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.startUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard locationManager.authorizationStatus != .denied else { return }
    guard let location = locations.last else { return }

    guard let oldLocation = self.oldLocation else {
      self.oldLocation = location
      newLocation(with: location)
      return
    }
    
    if location.distance(from: oldLocation) > 1000 {
      newLocation(with: location)
      self.oldLocation = location
    }
  }
  
  func newLocation(with location: CLLocation) {
    let latitude  = location.coordinate.latitude
    let longitude = location.coordinate.longitude
    
    lookUpCurrentLocation { [weak self] placemark in
      if let placemark = placemark {
        let name = placemark.locality!
        let location  = Location(name: name, lat: latitude, lon: longitude)
        self?.delegate?.locationsDidChange(location: location)
      }
    }
  }
  
  func lookUpCurrentLocation(completion: @escaping (CLPlacemark?) -> Void ) {
    guard let lastLocation = self.locationManager.location else {
      completion(nil)
      return
    }
    
    let geocoder = CLGeocoder()
    // Look up the location and pass it to the completion handler
    geocoder.reverseGeocodeLocation(lastLocation) { (placemarks, error) in
      if let _ = error {
        completion(nil)
      }
      
      let firstLocation = placemarks?[0]
      completion(firstLocation)
    }
  }
}
