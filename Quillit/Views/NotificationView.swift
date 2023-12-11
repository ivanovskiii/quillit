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
                HStack{
                    AsyncImage(url: URL(string: notification.user.profilePictureURL ?? "")) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        case .failure(let error):
                            Text("Failed to load image: \(error.localizedDescription)")
                        case .empty:
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    Text("\(notification.user.username) liked your quill.")
                }
            }
            
            if notification.type == .follow {
                HStack{
                    AsyncImage(url: URL(string: notification.user.profilePictureURL ?? "")) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        case .failure(let error):
                            Text("Failed to load image: \(error.localizedDescription)")
                        case .empty:
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    Text("\(notification.user.username) followed you.")
                }
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
