//
//  NotificationView.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 15.11.23.
//

import SwiftUI

struct NotificationView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @EnvironmentObject private var notificationViewModel: NotificationViewModel

    var body: some View {
        VStack {
            Text("Alerts")
                .font(Font.custom("Ahsing", size: 25))
            
            Spacer()

            List(notificationViewModel.notifications) { notification in
                    NotificationRowView(notification: notification)
            }
        }
        .onAppear {
            // Fetch notifications when the view appears
            Task {
                if let userID = authViewModel.currentUser?.id {
                    await notificationViewModel.fetchNotifications(forUserID: userID)
                }
            }
        }
    }
}

struct NotificationRowView: View {
    let notification: Notification

    var body: some View {
        HStack {
            if notification.type == .like {
                Text("\(notification.user.username) liked your quill.")
            }
            
            if notification.type == .follow {
                Text("\(notification.user.username) followed you.")
            }
            Spacer()
        }
        .padding()
    }
}






struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
