//
//  UserRepository.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 16.11.23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserRepository: ObservableObject {
    @Published var users: [User] = []

    private let store = Firestore.firestore()

        init() {
            fetchAllUsers()
            print("called init")
        }
    
    func fetchAllUsers() {
        store.collection("user").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching users: \(error)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No users found")
                return
            }

            let users = documents.compactMap { document in
                try? document.data(as: User.self)
            }

            DispatchQueue.main.async {
                self.users = users
            }
        }
    }

    
    func update(_ user: User) {
            if let index = users.firstIndex(where: { $0.id == user.id }) {
                users[index] = user
            }
        }
}
