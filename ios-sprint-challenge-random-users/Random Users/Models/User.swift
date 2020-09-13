//
//  User.swift
//  Random Users
//
//  Created by Michael McGrath on 9/12/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct UserResults: Codable {
    var results: [User]
}

struct User: Codable {
    let name: String
    let number: String
    let email: String
    let thumbnail: URL
    let fullSize: URL
    let id: String = UUID().uuidString
    
    enum UserKeys: String, CodingKey {
        case name
        case cell
        case email
        case thumbnail
        case large
        case title
        case first
        case last
        case picture
        case results
    }

    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: UserKeys.self)
        let nameContainer = try container.nestedContainer(keyedBy: UserKeys.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        let number = try container.decode(String.self, forKey: .cell)
        let email = try container.decode(String.self, forKey: .email)
        let pictureContainer = try container.nestedContainer(keyedBy: UserKeys.self, forKey: .picture)
        let thumbnail = try pictureContainer.decode(String.self, forKey: .thumbnail)
        let fullSize = try pictureContainer.decode(String.self, forKey: .large)
        
        
        self.name = "\(title) \(first) \(last)"
        self.number = number
        self.email = email
        self.thumbnail = URL(string: thumbnail)!
        self.fullSize = URL(string: fullSize)!
    }
}
