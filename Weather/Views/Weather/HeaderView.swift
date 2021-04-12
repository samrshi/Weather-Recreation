//
//  HeaderView.swift
//  Weather
//
//  Created by Samuel Shi on 10/24/20.
//

import SwiftUI

struct HeaderView: View {

  @Binding var showSheet: Bool
  let location: Location
  let response: OneCallResponse
  
  var body: some View {
    HStack(alignment: .top) {
      VStack(alignment: .leading) {
        Text("\(location.name)")
          .font(.largeTitle)
        
        Text(response.formattedDate())
          .foregroundColor(.secondary)
      }
      
      Spacer()
      
      Button(action: {
        showSheet.toggle()
      }) {
        Image(systemName: "magnifyingglass")
          .foregroundColor(.white)
          .font(.system(size: 20))
      }
    }
    .padding([.top, .horizontal])
  }
}
