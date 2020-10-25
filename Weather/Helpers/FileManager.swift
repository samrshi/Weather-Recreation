//
//  FileManager.swift
//  Weather
//
//  Created by Samuel Shi on 10/25/20.
//

import Foundation

extension FileManager {
  static func sharedContainerURL() -> URL {
    return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: "group.com.samrshi.Weather.contents"
    )!
  }
  
  static func readContents() -> Locations {
    var contents: Locations = Locations.staticInit()
    let archiveURL = FileManager.sharedContainerURL().appendingPathComponent("contents.json")
    
    let decoder = JSONDecoder()
    if let codeData = try? Data(contentsOf: archiveURL) {
      do {
        contents = try decoder.decode(Locations.self, from: codeData)
      } catch {
        print("Error: Can't decode contents")
      }
    }
    return contents
  }
}
