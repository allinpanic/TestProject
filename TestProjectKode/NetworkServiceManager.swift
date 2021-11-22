//
//  NetworkServiceManager.swift
//  TestProjectKode
//
//  Created by Rodianov on 11/21/21.
//

import Foundation

final class NetworkServiceManager {
  
  private let hostPath = "https://stoplight.io"
  private let path = "/mocks/kode-education/trainee-test/25143926/users"
  
  private func makeURLRequest(withURLPath path: String) -> URLRequest {
      let fullURL: URL
      let baseURL = URL(string: hostPath)!
      fullURL = baseURL.appendingPathComponent(path)
      
      let request = URLRequest(url: fullURL)
      
      return request
    }
  
  func employeesRequest() -> URLRequest {
    var request = makeURLRequest(withURLPath: path)
    
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("code=200, example=success", forHTTPHeaderField: "Prefer")
    
    return request
  }
  
  func errorRequest() -> URLRequest {
    var request = makeURLRequest(withURLPath: path)
    
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("code=500, example=error-500", forHTTPHeaderField: "Prefer")
    
    return request
  }
  
  func getData(request: URLRequest,
               session: URLSession,
               completionHandler: @escaping (Result<Data, Error>) -> Void) {
    
    let dataTask = session.dataTask(with: employeesRequest()) { data, response, error in
      if let error = error {
        completionHandler(.failure(error))
        return
      }
      
      if let httpResponse = response as? HTTPURLResponse {        
        if httpResponse.statusCode == 200 {
          guard let data = data else {return}
          completionHandler(.success(data))
        } else {
          if let error = error {
            completionHandler(.failure(error))
          }
        }
      }
    }
    dataTask.resume()
  }
  
  func parseJSON<T: Codable>(jsonData: Data, toType: T.Type) -> T? {
      let decoder = JSONDecoder()
//    decoder.keyDecodingStrategy = .convertFromSnakeCase

//      guard let result = try? decoder.decode(T.self, from: jsonData) else {
//        print("data decoding failed")
//        return nil
//      }
    
    do {
       let result = try decoder.decode(T.self, from: jsonData)
      
      return result
    } catch {
      print(error)
    }

      return nil
    }
}
