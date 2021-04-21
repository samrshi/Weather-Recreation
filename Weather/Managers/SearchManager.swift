//
//  LocationService.swift
//  Weather
//
//  Created by Samuel Shi on 10/14/20.
//

import Foundation
import Combine
import MapKit

class SearchManager: NSObject, ObservableObject {

  enum LocationStatus: Equatable {
    case idle
    case noResults
    case isSearching
    case error(String)
    case result
  }

  @Published var queryFragment: String = ""
  @Published private(set) var status: LocationStatus = .idle
  @Published private(set) var searchResults: [MKLocalSearchCompletion] = []

  private var queryCancellable: AnyCancellable?
  private let searchCompleter: MKLocalSearchCompleter!

  init(searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()) {
    self.searchCompleter = searchCompleter
    super.init()
    self.searchCompleter.delegate = self

    queryCancellable = $queryFragment
      .receive(on: DispatchQueue.main)
      .debounce(for: .milliseconds(250), scheduler: RunLoop.main, options: nil)
      .sink { fragment in
        self.status = .isSearching

        if !fragment.isEmpty {
          self.searchCompleter.queryFragment = fragment
        } else {
          self.status = .idle
          self.searchResults = []
        }
      }
  }
}

extension SearchManager: MKLocalSearchCompleterDelegate {
  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    self.searchResults = completer.results.filter({ $0.subtitle == "" })
    self.status = completer.results.isEmpty ? .noResults : .result
  }

  func completer(
    _ completer: MKLocalSearchCompleter,
    didFailWithError error: Error
  ) {
    self.status = .error(error.localizedDescription)
  }

  func findCity(
    completionResult: MKLocalSearchCompletion,
    completion: @escaping (Location) -> Void
  ) {
    let geocoder = CLGeocoder()

    geocoder.geocodeAddressString(completionResult.title) { placemarks, _ in
      guard let placemarks = placemarks else { return }
      guard let location = placemarks.first?.location else { return }
      var name = completionResult.title

      if let index = completionResult.title.firstIndex(of: ",") {
        let prefix = completionResult.title.prefix(upTo: index)
        name = String(prefix)
      }

      let result = Location(
        name: name,
        lat: location.coordinate.latitude,
        lon: location.coordinate.longitude,
        verboseName: completionResult.title
      )

      completion(result)
    }
  }

  func addCity(_ city: MKLocalSearchCompletion) {
    findCity(completionResult: city) { location in
      UserLocationsManager.shared.locations.append(location)
    }
  }
}
