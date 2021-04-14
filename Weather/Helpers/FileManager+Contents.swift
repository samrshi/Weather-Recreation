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
  
  static func readContents() -> [Location] {
    var contents: [Location] = []
    let archiveURL = FileManager.sharedContainerURL().appendingPathComponent("contents.json")
    
    let decoder = JSONDecoder()
    if let codeData = try? Data(contentsOf: archiveURL) {
      do {
        contents = try decoder.decode([Location].self, from: codeData)
      } catch {
        print("Error: Can't decode contents")
      }
    }
    return contents
  }
  
  static func writeContents(locations: [Location]) {
    let archiveURL = FileManager.sharedContainerURL()
      .appendingPathComponent("contents.json")
    let encoder = JSONEncoder()
    if let dataToSave = try? encoder.encode(locations) {
      do {
        try dataToSave.write(to: archiveURL)
      } catch {
        print("Error: Can't write contents")
        return
      }
    }
  }
}
