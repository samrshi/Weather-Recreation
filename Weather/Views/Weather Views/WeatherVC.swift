//
//  WeatherVC.swift
//  Weather
//
//  Created by Samuel Shi on 4/12/21.
//

import SwiftUI
import UIKit

class WeatherVC: UIViewController {
  let id = UUID().uuidString

  var location: Location?
  var manager: WeatherDataManager

  var weatherView: UIHostingController<WeatherView>!
  let backgroundView = UIView()
  let gradientLayer = CAGradientLayer()

  init(location: Location?) {
    self.location = location
    self.manager = WeatherDataManager(location: location)

    super.init(nibName: nil, bundle: nil)

    let name = NSNotification.Name(rawValue: id)
    let action = #selector(updateBackground)
    NotificationCenter.default.addObserver(self, selector: action, name: name, object: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureBackground()
    configureWeatherView()
    setUpConstraints()
  }

  override func viewDidLayoutSubviews() {
    weatherView.view.backgroundColor = .clear
  }

  @objc func updateBackground() {
    let colors = CurrentViewModel(manager.response).getBackgroundColors()
    gradientLayer.colors = colors.map { color in
      UIColor(color).cgColor
    }
  }

  func configureWeatherView() {
    let rootView = WeatherView(weather: manager, id: id)
    let weather = UIHostingController(rootView: rootView)
    weatherView = weather
    addChild(weather)
    view.addSubview(weather.view)
    weatherView.didMove(toParent: self)
  }

  func configureBackground() {
    gradientLayer.frame = view.bounds
    updateBackground()
    gradientLayer.shouldRasterize = true
    backgroundView.layer.addSublayer(gradientLayer)
    view.addSubview(backgroundView)
  }

  func setUpConstraints() {
    let safe = view.safeAreaLayoutGuide

    weatherView.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      weatherView.view.topAnchor.constraint(equalTo: safe.topAnchor),
      weatherView.view.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
      weatherView.view.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
      weatherView.view.trailingAnchor.constraint(equalTo: safe.trailingAnchor)
    ])

    backgroundView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
      backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension UIView {
  func pin(to superView: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: superView.topAnchor),
      leadingAnchor.constraint(equalTo: superView.leadingAnchor),
      trailingAnchor.constraint(equalTo: superView.trailingAnchor),
      bottomAnchor.constraint(equalTo: superView.bottomAnchor)
    ])
  }
}
