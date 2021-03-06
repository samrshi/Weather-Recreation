//
//  HourlyView.swift
//  Weather
//
//  Created by Samuel Shi on 9/28/20.
//

import SwiftUI

struct HourlyView: View {

  let hourly: HourlyViewModel

  var body: some View {
    HStack {
      ForEach(hourly.hours(), id: \.dt) { hour in
        VStack {
          time(hour)

          Image(systemName: hourly.icon(for: hour))
            .renderingMode(.original)
            .font(.headline)
            .frame(height: hourly.isWidget ? 30 : 50)

          Text(hourly.temp(for: hour))
            .font(hourly.isWidget ? .system(size: 12) : .headline)
            .fontWeight(.regular)
            .fixedSize()
        }
        .padding(.trailing, 6)

        if hour.dt != hourly.hours().last?.dt {
          Spacer()
        }
      }
    }
  }

  func time(_ hour: HourlyResponse) -> some View {
    let time = hourly.time(for: hour)

    return HStack(alignment: .bottom, spacing: 0) {
      Text(time)
        .font(hourly.isWidget ? .caption2 : .headline)
        .fontWeight(time == "Now" || hourly.isWidget
            ? .semibold
            : .regular
        )

      Text(hourly.period(for: hour))
        .font(hourly.isWidget ? .caption2 : .subheadline)
        .fontWeight(hourly.isWidget ? .semibold : .regular)
    }
    .fixedSize(horizontal: true, vertical: false)
  }
}
