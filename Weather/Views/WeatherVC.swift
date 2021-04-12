//
//  WeatherVC.swift
//  Weather
//
//  Created by Samuel Shi on 4/12/21.
//

import SwiftUI
import UIKit

class WeatherVC: UIViewController {
  var location: Location?
  var publisher: WeatherPublisher
  var weatherView: UIHostingController<WeatherView>!
  
  init(location: Location?) {
    self.location = location
    self.publisher = WeatherPublisher(location: location)
    
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    weatherView = UIHostingController(rootView: WeatherView(weather: publisher))
    view.addSubview(weatherView.view)
    
    weatherView.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      weatherView.view.topAnchor.constraint(equalTo: view.topAnchor),
      weatherView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      weatherView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      weatherView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
