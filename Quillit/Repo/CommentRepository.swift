//
//  CommentRepository.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 23.11.23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class CommentRepository: ObservableObject {
    
    private let store = Firestore.firestore()

        func addComment(_ comment: Comment, to quillID: String) {
            do {
                try store.collection("quills").document(quillID).collection("comments").document(comment.id).setData(from: comment)
                print("Comment added successfully in Firestore!")
            } catch {
                print("Error adding comment in Firestore: \(error)")
            }
        }

}
