//
//  QuillViewModel.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 17.11.23.
//

import Combine
import Foundation

final class QuillViewModel: ObservableObject{
    @Published var quillRepository = QuillRepository()
    @Published var quills: [Quill] = []
    @Published var notifications: [String] = []
    @Published var userQuills: [Quill] = []
    @Published var commentRepository = CommentRepository()

    private var cancellables: Set<AnyCancellable> = []

    init(){
        quillRepository.$quills
            .assign(to: \.quills, on: self)
            .store(in: &cancellables)
    }

    func add(_ quill: Quill){
        quillRepository.add(quill)
    }
    
    func delete(_ quill: Quill) {
        quillRepository.delete(quill)
    }
    
    func update(_ quill: Quill) {
        do{
           try  quillRepository.update(quill)
        } catch{
            print("Could not update Quill!")
        }
    }
    
    func toggleLike(_ quill: Quill, userID: String?) {
        guard let currentUserID = userID else { return }

        var updatedQuill = quill

        if quill.isLiked(by: currentUserID) {
            // Unlike the quill
            updatedQuill.likedBy.removeAll { $0 == currentUserID }
        } else {
            // Like the quill
            updatedQuill.likedBy.append(currentUserID)
        }

        // Update the quill in the repository
        update(updatedQuill)
    }
    
    func displayLikeNotification(quill: Quill) {
            let notificationMessage = quill.likeNotificationMessage
            notifications.append(notificationMessage) // Store the notification
    }

    func clearNotifications() {
        notifications.removeAll()
    }


}
