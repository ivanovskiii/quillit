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
    @State private var showContextMenu = false
    
    // Introduce a new parameter to represent the user (optional)
    var user: User?
    
    // Determine if the profile being displayed is the current user's profile
    private var isCurrentUserProfile: Bool {
        return user?.id == authViewModel.currentUser?.id
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("\(user?.username ?? authViewModel.currentUser?.username ?? "username")")
                    .font(Font.custom("Ahsing", size: 25))
                
                // Show gear icon and options only for the current user's profile
                if isCurrentUserProfile {
                    Image(systemName: "gearshape")
                        .font(Font.custom("SpaceMono-Regular", size: 18))
                        .onTapGesture {
                            showContextMenu = true
                        }
                        .confirmationDialog("Options", isPresented: $showContextMenu, titleVisibility: .visible){
                            Button("Log Out from @\(user?.username ?? authViewModel.currentUser?.username ?? "username")", role: .destructive){
                                authViewModel.signOut()
                            }
                        }
                }
            }
            
            ScrollView {
                Circle()
                    .frame(width: 100)
                HStack (spacing: 60) {
                    Text("Followers: \(user?.followers.count ?? authViewModel.currentUser?.followers.count ?? 0)")
                        .font(Font.custom("SpaceMono-Regular", size: 15))
                    Text("Following: \(user?.following.count ?? authViewModel.currentUser?.following.count ?? 0)")
                        .font(Font.custom("SpaceMono-Regular", size: 15))
                }
                
                ForEach(quillViewModel.quills.sorted(by: { $0.postedDateTime > $1.postedDateTime })) { quill in
                    // Check if the provided user matches the quill's user
                    if user?.id == quill.user.id || isCurrentUserProfile {
                        QuillCardView(quill: quill)
                            .padding(.bottom, 5)
                    }
                }
            }
            
            Spacer()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        // For preview, pass a specific user or leave it nil to display the current user's profile
        ProfileView(quillViewModel: QuillViewModel(), user: nil)
            .environmentObject(AuthViewModel())
    }
}
