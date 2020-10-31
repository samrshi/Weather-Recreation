//
//  WidgetViewModel.swift
//  Weather
//
//  Created by Samuel Shi on 10/26/20.
//

import Foundation

struct WidgetViewModel {
  let current: CurrentViewModel
  let hourly: HourlyViewModel
  
  init(weather: OneCallResponse) {
    current = CurrentViewModel(weather, isWidget: true)
    hourly = HourlyViewModel(weather, isWidget: true)
  }
}
