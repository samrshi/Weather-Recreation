//
//  TabViewController.swift
//  UIKit + SwiftUI TabView
//
//  Created by Samuel Shi on 3/29/21.
//

import SwiftUI
import UIKit

struct PageViewController: UIViewControllerRepresentable {
  @Binding var pages: [WeatherVC]
  @Binding var currentPage: Int
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  func makeUIViewController(context: Context) -> UIPageViewController {
    let pageViewController = UIPageViewController(
      transitionStyle: .scroll,
      navigationOrientation: .horizontal)
    pageViewController.dataSource = context.coordinator
    pageViewController.delegate = context.coordinator
    
    let pageControl = UIPageControl()
    pageControl.numberOfPages = pages.count

    pageViewController.view.addSubview(pageControl)
    
    return pageViewController
  }
  
  func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
    pageViewController.setViewControllers(
      [context.coordinator.controllers[currentPage]],
      direction: .reverse, animated: true
    )
  }
  
  class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var parent: PageViewController
    var controllers = [UIViewController]()
    
    init(_ pageViewController: PageViewController) {
      parent = pageViewController
      controllers = parent.pages
    }
    
    func pageViewController(
      _ pageViewController: UIPageViewController,
      viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
      guard let index = controllers.firstIndex(of: viewController) else { return nil }
      if index == 0 {
        return nil
      }
      return controllers[index - 1]
    }
    
    func pageViewController(
      _ pageViewController: UIPageViewController,
      viewControllerAfter
      viewController: UIViewController) -> UIViewController?
    {
      guard let index = controllers.firstIndex(of: viewController) else { return nil }
      if index == controllers.count - 1 {
        return nil
      }
      return controllers[index + 1]
    }
    
    func pageViewController(
      _ pageViewController: UIPageViewController,
      didFinishAnimating finished: Bool,
      previousViewControllers: [UIViewController],
      transitionCompleted completed: Bool) {
      if completed, let visibleViewController = pageViewController.viewControllers?.first,
         let index = controllers.firstIndex(of: visibleViewController) {
        parent.currentPage = index
      }
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.gray
        appearance.currentPageIndicatorTintColor = UIColor.white
        appearance.backgroundColor = UIColor.darkGray
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        setupPageControl()
        return controllers.count
    }
  }
}
