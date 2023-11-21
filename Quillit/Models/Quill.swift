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
    var likedBy: [String]
    var comments: [Comment]
    var postedDateTime: Date
    
    func isLiked(by userID: String) -> Bool {
        return likedBy.contains(userID)
    }
    
    var likeNotificationMessage: String {
            guard let firstLiker = likedBy.first else {
                return ""
            }
            return "\(firstLiker) and others liked your quill '\(title)'"
        }
    
}
