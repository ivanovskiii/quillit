//
//  UserViewModel.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 21.11.23.
//

import Foundation
import UIKit
import SwiftUI
import Combine

@MainActor
class UserViewModel: ObservableObject {
    @Published var userRepository = UserRepository()
    @Published var notificationRepository = NotificationRepository()
    @Published var users: [User] = []

    private var cancellables: Set<AnyCancellable> = []

    init() {
        userRepository.$users
            .assign(to: \.users, on: self)
            .store(in: &cancellables)
    }

    func followUser(currentUserID: String, otherUserID: String, isFollowing: Bool) {
        userRepository.followUser(currentUserID: currentUserID, otherUserID: otherUserID, isFollowing: isFollowing)

        if isFollowing {
                // If the user is being followed, create and store a follow notification
                userRepository.fetchUserByID(userID: currentUserID) { fetchedCurrentUser in
                    if let currentUser = fetchedCurrentUser {
                        let followNotification = Notification(id: UUID().uuidString, type: .follow, user: currentUser)
                        Task {
                            await self.notificationRepository.storeNotification(followNotification, forUserId: otherUserID)
                        }
                    } else {
                        print("Error fetching current user for follow notification")
                    }
                }
            }
    }
    
    func fetchUserByID(userID: String, completion: @escaping (User?) -> Void) {
        userRepository.fetchUserByID(userID: userID, completion: completion)
    }

    func userIsFollowed(currentUserID: String, otherUserID: String) -> Bool {
        guard let currentUser = users.first(where: { $0.id == currentUserID }) else {
            return false
        }
        return currentUser.following.contains(where: { $0 == otherUserID })
    }
    
    func uploadProfilePicture(userID: String, image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        userRepository.uploadProfilePicture(image: image, userID: userID, completion: completion)
    }
    
    
}

