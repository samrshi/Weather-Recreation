//
//  TabViewController.swift
//  UIKit + SwiftUI TabView
//
//  Created by Samuel Shi on 3/29/21.
//

import SwiftUI
import UIKit

struct PageVC: UIViewControllerRepresentable {
  var pages: [WeatherVC]

  @Binding var currentPage: Int
  @Binding var showSearchSheet: Bool

  let cityListButton = UIButton(type: .system)
  let pageViewController = {
    UIPageViewController(
      transitionStyle: .scroll,
      navigationOrientation: .horizontal
    )
  }()

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  func makeUIViewController(context: Context) -> UIPageViewController {
    pageViewController.dataSource = context.coordinator
    pageViewController.delegate   = context.coordinator

    configurePageControl(context: context)
    configureButton(context: context)
    setUpConstraints(context: context)

    return pageViewController
  }

  func updateUIViewController(
    _ pageViewController: UIPageViewController,
    context: Context
  ) {
    let pageControl = context.coordinator.pageControl

    var direction: UIPageViewController.NavigationDirection = .forward
    let animated = pageControl.currentPage != currentPage

    if pageControl.currentPage > currentPage {
      direction = .reverse
    }

    pageControl.currentPage         = currentPage
    pageControl.numberOfPages       = pages.count
    context.coordinator.controllers = pages

    var newIndex = currentPage
    if currentPage == pages.count {
      newIndex = 0
    }

    pageViewController.setViewControllers(
      [context.coordinator.controllers[newIndex]],
      direction: direction, animated: animated
    )
  }

  func configurePageControl(context: Context) {
    let pageControl = context.coordinator.pageControl
    let locationImage = UIImage(systemName: "location.fill")

    pageControl.currentPage              = currentPage
    pageControl.numberOfPages            = pages.count
    pageControl.backgroundStyle          = .minimal
    pageControl.isUserInteractionEnabled = false
    pageControl.setIndicatorImage(locationImage, forPage: 0)

    pageViewController.view.addSubview(pageControl)
  }

  func configureButton(context: Context) {
    let listImage = UIImage(systemName: "list.dash")!

    cityListButton.setImage(listImage, for: .normal)
    cityListButton.tintColor = .white
    cityListButton.addTarget(
      context.coordinator,
      action: #selector(Coordinator.showSearch),
      for: .touchUpInside
    )

    pageViewController.view.addSubview(cityListButton)
  }

  func setUpConstraints(context: Context) {
    guard let view = pageViewController.view else { fatalError() }
    let safe = view.safeAreaLayoutGuide
    let pageControl = context.coordinator.pageControl

    pageControl.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      pageControl.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -12),
      pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      pageControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75)
    ])

    cityListButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      cityListButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -12),
      cityListButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
    ])
  }
}
