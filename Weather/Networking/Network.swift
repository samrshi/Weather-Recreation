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

public class Network {
  static func fetch<T: Decodable>(
    type: T.Type,
    urlString: String,
    decodingStrategy: JSONDecoder.KeyDecodingStrategy,
    completion: @escaping (Result<T, NetworkError>
  ) -> Void) {
    guard let url = URL(string: urlString) else {
      let error: NetworkError = .badURL(message: "Invalid URL")
      completion(.failure(error))
      return
    }

    URLSession.shared.dataTask(with: url) { data, _, error in
      if let error = error {
        let message = "Error: \(error.localizedDescription)"
        let error: NetworkError = .requestFailed(message: message)
        completion(.failure(error))
        return
      }

      guard let data = data else {
        let error: NetworkError = .unknown(message: "Unknown Error")
        completion(.failure(error))
        return
      }

      DispatchQueue.main.async {
        do {
          let decoder = JSONDecoder()
          decoder.keyDecodingStrategy = decodingStrategy

          let result = try decoder.decode(T.self, from: data)
          completion(.success(result))
        } catch let error {
          let message = "Unknown Error: \(error.localizedDescription)"
          let error: NetworkError = .unknown(message: message)
          completion(.failure(error))
        }
      }
    }.resume()
  }
}
