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
    
    @State private var isImagePickerPresented: Bool = false
    @State private var selectedImage: UIImage?
    @State private var profilePicture: UIImage?
    
    @State private var isUploading = false

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
                AsyncImage(url: URL(string: user?.profilePictureURL ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    case .failure(let error):
                        Text("Failed to load image: \(error.localizedDescription)")
                    case .empty:
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                    @unknown default:
                        EmptyView()
                    }
                }
                    .onTapGesture {
                        isImagePickerPresented = true
                    }
                    .sheet(isPresented: $isImagePickerPresented){
                        ImagePickerView(image: $selectedImage)
                        
                    }
                    .onChange(of: selectedImage) { newImage in
                        if newImage != nil {
                            uploadProfilePicture()
                        }
                    }
                    .onAppear {
                    }
                    .background(
                        profilePicture.map {
                        Image(uiImage: $0)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        }
                    )
                
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
                                .padding(.horizontal, 145)
                                .background(userViewModel.userIsFollowed(currentUserID: authViewModel.currentUser?.id ?? "", otherUserID: user?.id ?? "")
                                            ? Color("QBlack")
                                            : Color("QRed"))
                                .cornerRadius(10)
                        }
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
            .overlay(
                isUploading ? ProgressView("Uploading Profile Picture...") : nil
            )
            .disabled(isUploading) // Disable interaction while uploading
            .blur(radius: isUploading ? 3 : 0)


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
    
    private func uploadProfilePicture() {
        guard let userID = user?.id, let selectedImage = selectedImage else {
            return
        }
        
        isUploading = true

        userViewModel.uploadProfilePicture(userID: userID, image: selectedImage) { result in
            switch result {
            case .success(let imageURL):
                print("Profile picture uploaded successfully. URL: \(imageURL)")
                isUploading = false

            case .failure(let error):
                print("Error uploading profile picture: \(error)")
                isUploading = false
            }
        }
    }
    

    

}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(quillViewModel: QuillViewModel(), userViewModel: UserViewModel(), user: nil)
            .environmentObject(AuthViewModel())
    }
}
