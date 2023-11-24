//
//  NotificationView.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 15.11.23.
//

import SwiftUI

struct NotificationView: View {
    @EnvironmentObject private var quillViewModel: QuillViewModel
    @EnvironmentObject private var authViewModel: AuthViewModel
    @EnvironmentObject private var userViewModel: UserViewModel

    var body: some View {
        VStack {
            Text("Alerts")
                .font(Font.custom("Ahsing", size: 25))
            
            Spacer()

            List(quillViewModel.notifications) { notification in
                if notification.type == .like {
                    // Directly use the non-optional user object
                    NotificationRowView(user: notification.user)
                }
            }
        }
        .onAppear {
            // Fetch notifications when the view appears
            Task {
                if let userID = authViewModel.currentUser?.id {
                    await quillViewModel.fetchNotifications(forUserID: userID)
                }
            }
        }
    }
}

struct NotificationRowView: View {
    let user: User

    var body: some View {
        HStack {
            // You can customize the view based on the notification
            Text("\(user.username) liked your quill")
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
