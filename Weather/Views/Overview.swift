//
//  DetailView.swift
//  Weather
//
//  Created by Samuel Shi on 10/4/20.
//

import SwiftUI

struct Overview: View {
  let columns = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  
  let data = (1...100).map { "Item \($0)" }
  
  var body: some View {
    LazyVGrid(columns: columns) {
      ForEach(data, id: \.self) { item in
        HStack {
          Text(item)
          
          Spacer()
        }
        .padding(.bottom)
      }
    }
    .padding()
  }
}

struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    Overview()
  }
}
