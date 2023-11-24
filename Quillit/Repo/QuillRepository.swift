//
//  QuillRepository.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 17.11.23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

final class QuillRepository: ObservableObject{
    private let store = Firestore.firestore()
    private let path = "quills"
    @Published var quills: [Quill] = []
    @Published var commentRepository = CommentRepository()
    
    init(){
        get()
        print("called quill repository init")
    }
    
    func get(){
        store.collection(path).addSnapshotListener { (snapshot, error) in
            if let error = error{
                print(error)
                return
            }
            self.quills = snapshot?.documents.compactMap {
                try? $0.data(as: Quill.self)
            } ?? []
        }
    }
    
    func add(_ quill: Quill){
        do{
            _ = try store.collection(path).addDocument(from: quill)
        } catch{
            fatalError("Adding quill failed!")
        }
    }
    
    func delete(_ quill: Quill) {
            if let documentId = quill.id {
                store.collection("quills").document(documentId).delete() { error in
                    if let error = error {
                        print("Error deleting quill: \(error)")
                    }
                }
            }
        }
    
    func update(_ quill: Quill) throws {
            do {
                try store.collection("quills").document(quill.id!).setData(from: quill)
                print("Quill updated successfully in Firestore!")
            } catch {
                print("Error updating quill in Firestore: \(error)")
            }
        }
    
    func addComment(to quill: Quill, comment: Comment, completion: @escaping (Result<Void, Error>) -> Void) {
            do {
                let _ = try store.collection("quills").document(quill.id!).collection("comments").addDocument(from: comment)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }

        func fetchComments(for quill: Quill, completion: @escaping (Result<[Comment], Error>) -> Void) {
            store.collection("quills").document(quill.id!).collection("comments").addSnapshotListener { querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    completion(.success([]))
                    return
                }

                let comments = documents.compactMap { document in
                    try? document.data(as: Comment.self)
                }

                completion(.success(comments))
            }
        }

    
}
