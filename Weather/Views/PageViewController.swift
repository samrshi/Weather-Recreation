//
//  TabViewController.swift
//  UIKit + SwiftUI TabView
//
//  Created by Samuel Shi on 3/29/21.
//

import SwiftUI
import UIKit

struct PageViewController: UIViewControllerRepresentable {
  var pages: [WeatherVC]
  @Binding var currentPage: Int
  @Binding var showSearchSheet: Bool
  
  let showSearchButton = UIButton(type: .system)
  let pageViewController = {
    UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
  }()
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  func makeUIViewController(context: Context) -> UIPageViewController {
    pageViewController.dataSource = context.coordinator
    pageViewController.delegate = context.coordinator
    
    configurePageControl(context: context)
    configureButton(context: context)
    setUpConstraints(context: context)
        
    return pageViewController
  }
  
  func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
    var direction: UIPageViewController.NavigationDirection = .forward
    let animated = context.coordinator.pageControl.currentPage != currentPage
    
    if context.coordinator.pageControl.currentPage > currentPage {
      direction = .reverse
    }
    pageViewController.reloadInputViews()
    context.coordinator.controllers = pages
    
    context.coordinator.pageControl.numberOfPages = pages.count
    context.coordinator.pageControl.currentPage = currentPage
    
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
    context.coordinator.pageControl.numberOfPages = pages.count
    context.coordinator.pageControl.currentPage = currentPage
    context.coordinator.pageControl.backgroundStyle = .minimal
    context.coordinator.pageControl.isUserInteractionEnabled = false // change this if i want to implement vc change on tap
    context.coordinator.pageControl.setIndicatorImage(UIImage(systemName: "location.fill"), forPage: 0)
    pageViewController.view.addSubview(context.coordinator.pageControl)
  }
  
  func configureButton(context: Context) {
    showSearchButton.setImage(UIImage(systemName: "list.dash")!.withRenderingMode(.alwaysTemplate), for: .normal)
    showSearchButton.tintColor = .white
    showSearchButton.addTarget(context.coordinator, action: #selector(Coordinator.showSearch), for: .touchUpInside)
    pageViewController.view.addSubview(showSearchButton)
  }
  
  func setUpConstraints(context: Context) {
    guard let view = pageViewController.view else { fatalError() }
    let safe = view.safeAreaLayoutGuide
    
    context.coordinator.pageControl.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      context.coordinator.pageControl.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -12),
      context.coordinator.pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      context.coordinator.pageControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75)
    ])
    
    showSearchButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      showSearchButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -12),
      showSearchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
    ])
  }
}

extension PageViewController {
  class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var parent: PageViewController
    var controllers = [UIViewController]()
    
    let pageControl = UIPageControl()
    
    init(_ pageViewController: PageViewController) {
      parent = pageViewController
      controllers = parent.pages
    }
    
    @objc func showSearch() {
      parent.showSearchSheet.toggle()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
      viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
      guard let index = controllers.firstIndex(of: viewController) else { return nil }
      if index == 0 {
        return nil
      }
      return controllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
      guard let index = controllers.firstIndex(of: viewController) else { return nil }
      if index == controllers.count - 1 {
        return nil
      }
      return controllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
      previousViewControllers: [UIViewController], transitionCompleted completed: Bool
    ) {
      if completed, let visibleViewController = pageViewController.viewControllers?.first,
         let index = controllers.firstIndex(of: visibleViewController) {
        parent.currentPage = index
        pageControl.currentPage = index
      }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return controllers.count
    }
  }
}
