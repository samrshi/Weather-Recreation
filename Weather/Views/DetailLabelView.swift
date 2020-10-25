//
//  DetailLabelView.swift
//  Weather
//
//  Created by Samuel Shi on 10/4/20.
//

import SwiftUI

struct DetailLabelView: View {
  let data: DataGroup
  
  var body: some View {
    HStack {
      HStack {
        VStack(alignment: .leading) {
          Text(data.title1.uppercased())
            .font(.caption2)
            .foregroundColor(.secondary)
          
          Text(data.data1)
            .font(.title3)
        }
        Spacer()
      }
      .frame(width: UIScreen.main.bounds.width / 2)
      
      VStack(alignment: .leading) {
        Text(data.title2.uppercased())
          .font(.caption2)
          .foregroundColor(.secondary)
        
        Text(data.data2)
          .font(.title3)
      }
      Spacer()
    }
  }
}
