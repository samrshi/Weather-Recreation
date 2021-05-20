//
//  LocationManager.swift
//  Weather
//
//  Created by Samuel Shi on 4/11/21.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
  func locationsDidChange(location: Location)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
  private let locationManager = CLLocationManager()

  let minDistance: Double = 1000
  var oldLocation: CLLocation?
  weak var delegate: LocationManagerDelegate?

  override init() {
    super.init()

    self.locationManager.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer

    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.startUpdatingLocation()
  }

  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
    guard locationManager.authorizationStatus != .denied else { return }
    guard let location = locations.last else { return }

    guard let oldLocation = self.oldLocation else {
      self.oldLocation = location
      newLocation(with: location)
      return
    }

    if location.distance(from: oldLocation) > minDistance {
      newLocation(with: location)
      self.oldLocation = location
    }
  }

  func newLocation(with location: CLLocation) {
    let latitude  = location.coordinate.latitude
    let longitude = location.coordinate.longitude

    lookUpCurrentLocation { [weak self] placemark in
      if let placemark = placemark {
        let name       = placemark.locality!
        let location   = Location(name: name, lat: latitude, lon: longitude)

        self?.delegate?.locationsDidChange(location: location)
      }
    }
  }

  func lookUpCurrentLocation(completion: @escaping (CLPlacemark?) -> Void) {
    guard let lastLocation = self.locationManager.location else {
      completion(nil)
      return
    }

    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(lastLocation) { (placemarks, error) in
      if error != nil {
        completion(nil)
      }

      let firstLocation = placemarks?[0]
      completion(firstLocation)
    }
  }
}
