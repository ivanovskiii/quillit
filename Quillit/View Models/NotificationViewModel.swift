//
//  NotificationViewModel.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 1.12.23.
//

import Foundation
import FirebaseFirestore

final class NotificationViewModel: ObservableObject {
    @Published private var notificationRepository = NotificationRepository()
    @Published var notifications: [Notification] = [] {
            didSet {
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        }

    func storeNotification(_ notification: Notification, forUserId userId: String) async {
        await notificationRepository.storeNotification(notification, forUserId: userId)
    }

    func fetchNotifications(forUserID userId: String) async {
        await notificationRepository.fetchNotifications(forUserID: userId)
        notifications = notificationRepository.notifications
    }

    func updateNotifications(_ notifications: [Notification], forUserId userId: String) {
        notificationRepository.updateNotifications(notifications, forUserId: userId)
    }
}
