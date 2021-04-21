//
//  PagingCoordinator.swift
//  Weather
//
//  Created by Samuel Shi on 4/20/21.
//

import SwiftUI

extension PageVC {
  class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var parent: PageVC

    var controllers = [UIViewController]()
    let pageControl = UIPageControl()

    init(_ pageViewController: PageVC) {
      parent = pageViewController
      controllers = parent.pages
    }

    @objc func showSearch() {
      parent.showSearchSheet.toggle()
    }

    func pageViewController(
      _ pageViewController: UIPageViewController,
      viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
      guard let index = controllers.firstIndex(of: viewController) else { return nil }
      if index == 0 { return nil }

      return controllers[index - 1]
    }

    func pageViewController(
      _ pageViewController: UIPageViewController,
      viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
      guard let index = controllers.firstIndex(of: viewController) else { return nil }
      if index == controllers.count - 1 { return nil }

      return controllers[index + 1]
    }

    func pageViewController(
      _ pageViewController: UIPageViewController,
      didFinishAnimating finished: Bool,
      previousViewControllers: [UIViewController],
      transitionCompleted completed: Bool
    ) {
      if completed,
         let visibleViewController = pageViewController.viewControllers?.first,
         let index = controllers.firstIndex(of: visibleViewController) {
        parent.currentPage = index
        pageControl.currentPage = index
      }
    }
  }
}
