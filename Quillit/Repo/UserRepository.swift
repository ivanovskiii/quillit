//
//  UserRepository.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 16.11.23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

final class UserRepository: ObservableObject {
    @Published var users: [User] = []

    private let store = Firestore.firestore()

    init() {
        fetchAllUsers()
        print("called User Repository init")
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
    
    func fetchUserByID(userID: String, completion: @escaping (User?) -> Void) {
        store.collection("user").document(userID).getDocument { document, error in
            if let error = error {
                print("Error fetching user by ID: \(error)")
                completion(nil)
                return
            }

            guard let document = document, document.exists else {
                print("User not found by ID")
                completion(nil)
                return
            }

            do {
                let user = try document.data(as: User.self)
                completion(user)
            } catch {
                print("Error decoding user by ID: \(error)")
                completion(nil)
            }
        }
    }

    func update(_ user: User) {
        do {
            try store.collection("user").document(user.id).setData(from: user)
            print("User updated successfully in Firestore!")
        } catch {
            print("Error updating user in Firestore: \(error)")
        }
    }

    func followUser(currentUserID: String, otherUserID: String, isFollowing: Bool) {
        guard let currentUserIndex = users.firstIndex(where: { $0.id == currentUserID }),
              let otherUserIndex = users.firstIndex(where: { $0.id == otherUserID }) else {
            print("Invalid user indices")
            return
        }

        if isFollowing {
            // Unfollow
            users[currentUserIndex].following.removeAll { $0 == otherUserID }
            users[otherUserIndex].followers.removeAll { $0 == currentUserID }
        } else {
            // Follow
            users[currentUserIndex].following.append(otherUserID)
            users[otherUserIndex].followers.append(currentUserID)
        }

        // Update users in Firestore
        update(users[currentUserIndex])
        update(users[otherUserIndex])
    }
    
    func uploadProfilePicture(image: UIImage, userID: String, completion: @escaping (Result<String, Error>) -> Void) {
        let storageRef = Storage.storage().reference().child("profilePictures/\(userID).jpg")

        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Image conversion failed"])))
            return
        }

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
            } else {
                storageRef.downloadURL { url, error in
                    if let error = error {
                        completion(.failure(error))
                    } else if let downloadURL = url {
                        // Update the user's profilePictureURL in Firestore
                        self.store.collection("user").document(userID).updateData(["profilePictureURL": downloadURL.absoluteString])

                        completion(.success(downloadURL.absoluteString))
                    }
                }
            }
        }
    }

    
}
