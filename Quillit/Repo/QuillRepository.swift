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
            try store.collection(path).document(quill.id!).setData(from: quill)
            print("Quill updated successfully!")
        } catch {
            throw error
        }
    }

    
}
