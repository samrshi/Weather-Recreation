//
//  String+SpaceRemover.swift
//  Weather
//
//  Created by Samuel Shi on 3/12/21.
//

import Foundation

extension String {
  func spacesToPluses() -> String {
    return self.replacingOccurrences(of: " ", with: "+")
  }
}
