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
  
  @EnvironmentObject var userInfo: UserInfo
  @ObservedObject var locationService: LocationService = LocationService()
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Location Search")) {
          ZStack(alignment: .trailing) {
            TextField("Search", text: $locationService.queryFragment)
            // This is optional and simply displays an icon during an active search
            if locationService.status == .isSearching {
              Image(systemName: "clock")
                .foregroundColor(Color.gray)
            }
          }
        }
        
        if !locationService.queryFragment.isEmpty {
          Section(header: Text("Results")) {
            List {
              // With Xcode 12, this will not be necessary as it supports switch statements.
              Group {
                switch locationService.status {
                case .noResults:
                  Text("No Results")
                case .error(let description):
                  Text("Error: \(description)")
                default:
                  EmptyView()
                }
              }.foregroundColor(Color.gray)
              
              ForEach(locationService.searchResults, id: \.self) { completionResult in
                Button(action: {
                  locationService.findCity(completionResult: completionResult) { location in
                    userInfo.cities.cities.append(location)
                  }
                  self.presentationMode.wrappedValue.dismiss()
                }) {
                  Text(completionResult.title)
                    .foregroundColor(.gray)
                }
                .buttonStyle(PlainButtonStyle())
              }
            }
          }
        }
        
        Section(header: Text("My Cities")) {
          List {
            ForEach(userInfo.cities.cities, id: \.self) { city in
              Text(city.name)
            }
            .onDelete(perform: delete)
            .onMove(perform: move)
          }
          
          if userInfo.cities.cities.isEmpty {
            Text("Search for a city to add it to your cities list")
              .foregroundColor(.gray)
              .font(.callout)
          }
        }
      }
      .navigationBarItems(leading: EditButton(), trailing:
                            Button("Done")  {
                              presentationMode.wrappedValue.dismiss()
                            }
      )
      .navigationBarTitleDisplayMode(.inline)
    }
  }
  
  func delete(indexSet: IndexSet) {
    userInfo.cities.cities.remove(atOffsets: indexSet)
  }
  
  func move(indexSet: IndexSet, i: Int) {
    userInfo.cities.cities.move(fromOffsets: indexSet, toOffset: i)
  }
}

struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    SearchView()
  }
}
