//
//  Footer.swift
//  Weather
//
//  Created by Samuel Shi on 4/20/21.
//

import SwiftUI

struct FooterView: View {
  var body: some View {
    VStack {
      MyDivider()
        .offset(y: -8)

      Color.clear
        .frame(height: 65)
    }
  }
}
