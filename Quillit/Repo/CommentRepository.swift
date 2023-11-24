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

    func addComment(_ comment: Comment, to quillID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            // Add the comment directly to Firestore
            try store.collection("quills").document(quillID).collection("comments").document(comment.id).setData(from: comment)
            print("Comment added successfully in Firestore!")
            completion(.success(()))
        } catch {
            print("Error adding comment in Firestore: \(error)")
            completion(.failure(error))
        }
    }

    func get(for quillID: String, completion: @escaping (Result<[Comment], Error>) -> Void) {
        store.collection("quills").document(quillID).collection("comments").getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            let comments = querySnapshot?.documents.compactMap { document in
                try? document.data(as: Comment.self)
            } ?? []

            completion(.success(comments))
        }
    }
    
    func deleteComment(_ comment: Comment, from quillID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let commentID = comment.id  // Assuming comment.id is not optional

        store.collection("quills").document(quillID).collection("comments").document(commentID).delete { error in
            if let error = error {
                print("Error deleting comment: \(error)")
                completion(.failure(error))
            } else {
                print("Comment deleted successfully in Firestore!")
                completion(.success(()))
            }
        }
    }


}
