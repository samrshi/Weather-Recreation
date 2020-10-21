//
//  DetailLabelView.swift
//  Weather
//
//  Created by Samuel Shi on 10/4/20.
//

import SwiftUI

struct DetailLabelView: View {
  let label: String
  let data: String
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(label)
        .font(.caption2)
        .foregroundColor(.secondary)
      
      Text(data)
    }
  }
}

struct DetailLabelView_Previews: PreviewProvider {
  static var previews: some View {
    DetailLabelView(label: "SUNRISE", data: "7:14AM")
  }
}
