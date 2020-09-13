//
//  UserController.swift
//  Random Users
//
//  Created by Michael McGrath on 9/12/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class UserController {
    
    let baseURL = URL(string: "https://randomuser.me/api/")!
    var users = [User]()
    
    func fetchRandomUsers(completion: @escaping () -> Void) {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [
            URLQueryItem(name: "results", value: "1000")
        ]
        guard let requestURL = urlComponents?.url else {
            print("Returned out at request initializing")
            completion()
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching random users: \(error)")
                completion()
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("Bad response code fetching random users: \(response)")
                completion()
                return
            }
            guard let data = data else {
                print("Bad or no data returned from network call")
                completion()
                return
            }
            
            do {
                let randomUsers = try JSONDecoder().decode(UserResults.self, from: data)
                self.users = randomUsers.results
                completion()
            } catch {
                print("Error decoding random users: \(error)")
                completion()
                return
            }
        }.resume()
    }
    
    func fetchLargeImage(imageURL: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            if let error = error {
                print("Error fetching large image: \(error)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("No data or bad data when fetching large image.")
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
}
