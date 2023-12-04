//
//  NotificationRepository.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 1.12.23.
//

import Foundation
import FirebaseFirestore

final class NotificationRepository: ObservableObject {
    @Published var notifications: [Notification] = [] {
            didSet {
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        }
    
    func storeNotification(_ notification: Notification, forUserId userId: String) async {
        do {
            // Update the notifications in Firebase subcollection
            let collectionRef = Firestore.firestore().collection("user").document(userId).collection("notifications")

            // Use the synchronous 'addDocument' method to add a document to the subcollection
            try collectionRef.addDocument(from: notification)

        } catch {
            print("Error storing notification: \(error.localizedDescription)")
        }
    }
    
    func fetchNotifications(forUserID userId: String) async {
        do {
            // Fetch the user's notifications from Firebase
            let collectionRef = Firestore.firestore().collection("user").document(userId).collection("notifications")
            let documents = try await collectionRef.getDocuments()

            // Decode documents and update the local notifications array
            notifications = try documents.documents.compactMap {
                try $0.data(as: Notification.self, decoder: Firestore.Decoder())
            }
        } catch {
            print("Error fetching notifications: \(error.localizedDescription)")
        }
    }


    func updateNotifications(_ notifications: [Notification], forUserId userId: String) {
        // Update the user's notifications in Firebase
        // Replace "user" with your actual Firestore collection name for users

        let collectionRef = Firestore.firestore().collection("user")

        // Convert notifications to a format that Firestore can handle
        let notificationsData = notifications.map { notification in
            [
                "type": notification.type.rawValue,
                "user": notification.user
            ]
        }

        // Update the specific user document with the new notifications field
        collectionRef.document(userId).setData(["notifications": notificationsData], merge: true)
    }
}
