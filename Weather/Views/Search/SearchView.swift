//
//  SearchView.swift
//  Weather
//
//  Created by Samuel Shi on 9/29/20.
//

import SwiftUI
import MapKit
import CoreLocation

struct SearchView: View {
  @Environment(\.presentationMode) var presentationMode
  
  @ObservedObject var userLocations = UserLocations.shared
  @StateObject var manager = SearchManager()
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Location Search")) {
          searchField
          
          if !manager.queryFragment.isEmpty {
            searchResults
          }
        }
        
        Section(header: Text("My Cities")) {
          List {
            ForEach(userLocations.locations.cities, id: \.self) { city in
              Text(city.name)
            }
            .onDelete(perform: deleteCity)
            .onMove(perform: reorderCity)
          }
          
          if userLocations.locations.cities.isEmpty {
            Text("Search for a city to add it to your cities list")
              .foregroundColor(.gray)
              .font(.callout)
          }
        }
      }
      .navigationBarItems(
        leading:
          EditButton(),
        trailing:
          Button("Done")  {
            presentationMode.wrappedValue.dismiss()
          }
      )
      .navigationBarTitleDisplayMode(.inline)
    }
  }
  
  var searchField: some View {
    ZStack(alignment: .trailing) {
      TextField("Search", text: $manager.queryFragment)
      
      if manager.status == .isSearching {
        Image(systemName: "clock")
          .foregroundColor(Color.gray)
      }
    }
  }
  
  var searchResults: some View {
    Section(header: Text("Results")) {
      List {
        resultsStatus
        
        ForEach(manager.searchResults, id: \.self) { completionResult in
          Button(action: {
            manager.addCity(completionResult)
            presentationMode.wrappedValue.dismiss()
          }) {
            Text(completionResult.title)
              .foregroundColor(.gray)
          }
          .buttonStyle(PlainButtonStyle())
        }
      }
    }
  }
  
  var resultsStatus: some View {
    Group {
      switch manager.status {
      case .noResults:
        Text("No Results")
      case .error(let description):
        Text("Error: \(description)")
      default:
        EmptyView()
      }
    }
    .foregroundColor(Color.gray)
  }
  
  func deleteCity(indexSet: IndexSet) {
    userLocations.locations.cities.remove(atOffsets: indexSet)
  }
  
  func reorderCity(indexSet: IndexSet, i: Int) {
    userLocations.locations.cities.move(fromOffsets: indexSet, toOffset: i)
  }
}

struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    SearchView()
  }
}
