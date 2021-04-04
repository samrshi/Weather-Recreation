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
  
  @ObservedObject var userInfo = UserInfo.shared
  @ObservedObject var manager = SearchManager()
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Location Search")) {
          ZStack(alignment: .trailing) {
            TextField("Search", text: $manager.queryFragment)
            
            if manager.status == .isSearching {
              Image(systemName: "clock")
                .foregroundColor(Color.gray)
            }
          }
        }
        
        if !manager.queryFragment.isEmpty {
          Section(header: Text("Results")) {
            List {
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
              
              ForEach(manager.searchResults, id: \.self) { completionResult in
                Button(action: {
                  addCity(completionResult)
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
            ForEach(userInfo.locations.cities, id: \.self) { city in
              Text(city.name)
            }
            .onDelete(perform: delete)
            .onMove(perform: move)
          }
          
          if userInfo.locations.cities.isEmpty {
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
  
  func addCity(_ city: MKLocalSearchCompletion) {
    manager.findCity(completionResult: city) { location in
      userInfo.locations.cities.append(location)
    }
    self.presentationMode.wrappedValue.dismiss()
  }
  
  func delete(indexSet: IndexSet) {
    userInfo.locations.cities.remove(atOffsets: indexSet)
  }
  
  func move(indexSet: IndexSet, i: Int) {
    userInfo.locations.cities.move(fromOffsets: indexSet, toOffset: i)
  }
}

struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    SearchView()
  }
}
