//
//  DetailView.swift
//  Weather
//
//  Created by Samuel Shi on 10/4/20.
//

import SwiftUI

struct Overview: View {
  
  let overview: OverviewViewModel
  
  var body: some View {
    VStack {
      ForEach(overview.overviewData(), id: \.self) { item in
        VStack {
          DetailLabelView(data: item)
          MyDivider()
        }
        .padding(.horizontal)
      }
    }
  }
}
