//
//  User.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 15.11.23.
//

import Foundation

struct User: Identifiable, Codable, Equatable{
    var id: String
    var username: String
    var email: String
    var followers: [String]
    var following: [String]
    var profilePictureURL: String?
    
    static func == (lhs: User, rhs: User) -> Bool {
            return lhs.id == rhs.id
        }
}
