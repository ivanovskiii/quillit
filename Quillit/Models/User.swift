//
//  User.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 15.11.23.
//

import Foundation

struct User: Identifiable, Codable{
    var id: String
    var username: String
    var email: String
    var followers: [User]
    var following: [User]
}
