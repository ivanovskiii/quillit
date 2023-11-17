//
//  Comment.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 15.11.23.
//

import Foundation

struct Comment: Identifiable, Codable{
    var id: String
    var content: String
    var user: User
    var likedBy: [User]
    var replies: [Comment]
    var postedDateTime: Date
}
