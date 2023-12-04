//
//  ProfileView.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 15.11.23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var quillViewModel: QuillViewModel
    @ObservedObject var userViewModel: UserViewModel

    @State private var showContextMenu = false

    var user: User?

    private var isCurrentUserProfile: Bool {
        return user?.id == authViewModel.currentUser?.id
    }
    
    

    var body: some View {
        VStack {
            HStack {
                Text("\(user?.username ?? authViewModel.currentUser?.username ?? "username")")
                    .font(Font.custom("Ahsing", size: 25))


                if isCurrentUserProfile {
                    Image(systemName: "gearshape")
                        .font(Font.custom("SpaceMono-Regular", size: 18))
                        .onTapGesture {
                            showContextMenu = true
                        }
                        .confirmationDialog("Options", isPresented: $showContextMenu, titleVisibility: .visible) {
                            Button("Log Out from @\(user?.username ?? authViewModel.currentUser?.username ?? "username")", role: .destructive) {
                                authViewModel.signOut()
                            }
                        }
                }
                
            }

            ScrollView {
                Circle()
                    .frame(width: 100)
                
                    VStack{
                        HStack(spacing: 60) {
                            Text("Followers: \(user?.followers.count ?? authViewModel.currentUser?.followers.count ?? 0)")
                                .font(Font.custom("SpaceMono-Regular", size: 15))
                            Text("Following: \(user?.following.count ?? authViewModel.currentUser?.following.count ?? 0)")
                                .font(Font.custom("SpaceMono-Regular", size: 15))
                        }
                    
                    if !isCurrentUserProfile {
                        Button(action: {
                            toggleFollow()
                        }) {
                            Text(userViewModel.userIsFollowed(currentUserID: authViewModel.currentUser?.id ?? "", otherUserID: user?.id ?? "")
                                 ? "Unfollow"
                                 : "Follow")
                                .font(Font.custom("SpaceMono-Regular", size: 15))
                                .foregroundColor(.white)
                                .padding()
                                .background(userViewModel.userIsFollowed(currentUserID: authViewModel.currentUser?.id ?? "", otherUserID: user?.id ?? "")
                                            ? Color("QBlack")
                                            : Color("QRed"))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 50)
                        Spacer()
                    }
                }

                ForEach(quillViewModel.quills.sorted(by: { $0.postedDateTime > $1.postedDateTime })) { quill in
                    if isCurrentUserProfile {
                        if authViewModel.currentUser?.id == quill.user.id {
                            QuillCardView(quill: quill)
                                .padding(.bottom, 5)
                        }
                    } else {
                        if user?.id == quill.user.id {
                            QuillCardView(quill: quill)
                                .padding(.bottom, 5)
                        }
                    }
                }
            }

            Spacer()
        }
    }

    private func toggleFollow() {
            guard let currentUserID = authViewModel.currentUser?.id, let otherUserID = user?.id else {
                return
            }
            let isFollowing = userViewModel.userIsFollowed(currentUserID: currentUserID, otherUserID: otherUserID)
            userViewModel.followUser(currentUserID: currentUserID, otherUserID: otherUserID, isFollowing: isFollowing)
        }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(quillViewModel: QuillViewModel(), userViewModel: UserViewModel(), user: nil)
            .environmentObject(AuthViewModel())
    }
}
