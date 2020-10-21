//
//  API.swift
//  Weather
//
//  Created by Samuel Shi on 9/28/20.
//

import Foundation

enum NetworkError: Error {
  case badURL(message: String)
  case requestFailed(message: String)
  case unknown(message: String)
}

public class API {
  static func fetch<T: Decodable>(type: T.Type, urlString: String, decodingStrategy: JSONDecoder.KeyDecodingStrategy, completion: @escaping (Result<T, NetworkError>) -> Void) {
    print(urlString)
    guard let url = URL(string: urlString) else {
      print("Invalid URL")
      completion(.failure(.badURL(message: "Invalid URL")))
      return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
      if let error = error {
        print("Error: \(error.localizedDescription)")
        completion(.failure(.requestFailed(message: "Error: \(error.localizedDescription)")))
        return
      }
      
      guard let data = data else { return }
      DispatchQueue.main.async {
        do {
          let decoder = JSONDecoder()
          decoder.keyDecodingStrategy = decodingStrategy
          let result = try decoder.decode(T.self, from: data)
          completion(.success(result))
        } catch let err {
          print(err)
          completion(.failure(.unknown(message: "Unknown Error: \(err.localizedDescription)")))
        }
      }
    }.resume()
  }
}
