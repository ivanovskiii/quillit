//
//  Quill.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 15.11.23.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Quill: Identifiable, Codable{
    @DocumentID var id: String?
    var title: String
    var content: String
    var user: User
    var likedBy: [User]
    var comments: [Comment]
    var postedDateTime: Date
    
}
