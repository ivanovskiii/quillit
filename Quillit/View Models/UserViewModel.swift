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
    @Published var users: [User] = []

    private var cancellables: Set<AnyCancellable> = []

    init() {
        userRepository.$users
            .assign(to: \.users, on: self)
            .store(in: &cancellables)
    }

    func followUser(currentUserID: String, otherUserID: String, isFollowing: Bool) {
        userRepository.followUser(currentUserID: currentUserID, otherUserID: otherUserID, isFollowing: isFollowing)
    }

    func userIsFollowed(currentUserID: String, otherUserID: String) -> Bool {
        guard let currentUser = users.first(where: { $0.id == currentUserID }) else {
            return false
        }
        return currentUser.following.contains(where: { $0 == otherUserID })
    }
}

