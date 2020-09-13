//
//  FetchUserPhotoOperation.swift
//  Random Users
//
//  Created by Michael McGrath on 9/12/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class FetchUserPhotoOperation: ConcurrentOperation {
    var user: User
    var image: UIImage?
    var dataTask: URLSessionDataTask?
    
    override func start() {
        state = .isExecuting
        let imageURL = user.thumbnail
        
        dataTask = URLSession.shared.dataTask(with: imageURL) { data, _, error in
            defer { self.state = .isFinished }
            if let error = error {
                print("Error retrieving image: \(error)")
                return
            }
            guard let data = data else {
                print("No data or bad data returned from image fetch")
                return
            }
            self.image = UIImage(data: data)
        }
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
    }
    
    init(user: User) {
        self.user = user
        super.init()
    }
}
