//
//  PagerView.swift
//  Weather
//
//  Created by Samuel Shi on 4/4/21.
//

import SwiftUI

struct PagerView<Content: View>: View {
  let pageCount: Int
  @Binding var currentIndex: Int
  let content: Content
  
  @GestureState private var translation: CGFloat = 0
  
  init(pageCount: Int, currentIndex: Binding<Int>, @ViewBuilder content: () -> Content) {
    self.pageCount = pageCount
    self._currentIndex = currentIndex
    self.content = content()
  }
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        HStack(spacing: 0) {
          self.content.frame(width: geometry.size.width)
        }
        .frame(width: geometry.size.width, alignment: .leading)
        .offset(x: -CGFloat(self.currentIndex) * geometry.size.width)
        .offset(x: self.translation)
        .animation(.interactiveSpring())
        .gesture(
          DragGesture().updating(self.$translation) { value, state, _ in
            state = value.translation.width
          }.onEnded { value in
            let offset = value.translation.width / geometry.size.width
            let newIndex = (CGFloat(self.currentIndex) - offset).rounded()
            self.currentIndex = min(max(Int(newIndex), 0), self.pageCount - 1)
          }
        )
        
        VStack {
          Spacer()
          
          HStack {
            Image(systemName: "location.fill")
              .resizable()
              .foregroundColor(0 == self.currentIndex ? Color.white : Color.gray)
              .frame(width: 12, height: 12)
            
            ForEach(1..<self.pageCount, id: \.self) { index in
              Circle()
                .fill(index == self.currentIndex ? Color.white : Color.gray)
                .frame(width: 10, height: 10)
            }
          }
          .padding()
        }
      }
    }
  }
}

struct StatefulPreview : View {
  @State private var index = 0
  
  var body: some View {
    PagerView(pageCount: 3, currentIndex: $index) {
      Color.blue
        .onAppear {
          print("hello")
        }
      Color.red
      Color.green
    }
    .ignoresSafeArea()
  }
}

#if DEBUG
struct PagerView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreview()
    }
}
#endif
