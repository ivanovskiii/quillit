//
//  QuillViewModel.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 17.11.23.
//

import Combine
import Foundation
import FirebaseFirestore

final class QuillViewModel: ObservableObject {
    @Published var quillRepository = QuillRepository()
    @Published var quills: [Quill] = []
    @Published var userQuills: [Quill] = []
    @Published var notifications: [Notification] = [] {
            didSet {
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        }
    
    @Published var notificationRepository = NotificationRepository()

    @Published var commentRepository = CommentRepository()

    private var cancellables: Set<AnyCancellable> = []

    init() {
        quillRepository.$quills
            .assign(to: \.quills, on: self)
            .store(in: &cancellables)
    }

    func add(_ quill: Quill) {
        quillRepository.add(quill)
    }

    func delete(_ quill: Quill) {
        quillRepository.delete(quill)
    }

    func update(_ quill: Quill) {
        do {
            try quillRepository.update(quill)
        } catch {
            print("Could not update Quill!")
        }
    }

    func toggleLike(_ quill: Quill, user: User?) async {
        guard let currentUser = user else { return }
        
        var updatedQuill = quill
        
        if quill.isLiked(by: currentUser.id) {
            // Unlike the quill
            updatedQuill.likedBy.removeAll { $0 == currentUser.id }
        } else {
            // Like the quill
            updatedQuill.likedBy.append(currentUser.id)
            
            // Notification
            let likeNotification = Notification(id: UUID().uuidString, type: .like, user: currentUser)
            print("toggleLike func: ", likeNotification)
            await notificationRepository.storeNotification(likeNotification, forUserId: quill.user.id)
        }
        // Update the quill in the repository
        update(updatedQuill)
    }
    
    
}
