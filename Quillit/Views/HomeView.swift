//
//  HomeView.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 15.11.23.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var quillViewModel: QuillViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var selectedTab = 0
    @State private var followingListIsEmpty = false

    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .center) {
                Image("quillit-logo-black")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .frame(maxWidth: .infinity, alignment: .top)
            }
            
            Picker("Tabs", selection: $selectedTab) {
                Text("✨ Discover").tag(0)
                    .font(Font.custom("SpaceMono-Regular", size: 13))
                Text("👥 Following").tag(1)
                    .font(Font.custom("SpaceMono-Regular", size: 13))
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .font(Font.custom("SpaceMono-Regular", size: 15))
            
            ScrollView {
                switch selectedTab {
                case 0:
                    
                    if(followingListIsEmpty){
                        ForEach(getRecentQuills()) { quill in
                            QuillCardView(quill: quill)
                                .padding(.bottom, 5)
                        }
                        
                    } else {

                        ForEach(getDiscoverQuills()) { quill in
                            QuillCardView(quill: quill)
                                .padding(.bottom, 5)
                        }
                        
                    }
                    
                case 1:
                    ForEach(getFollowingQuills()) { quill in
                        QuillCardView(quill: quill)
                            .padding(.bottom, 5)
                    }
                default:
                    EmptyView()
                }
            }
        }
        .onAppear {
            print("onAppear called")

            // Check if the user is logged in and currentUser is available
            if let currentUser = authViewModel.currentUser {
                if currentUser.following.isEmpty {
                    followingListIsEmpty = true
                    print("following list is empty")
                } else {
                    followingListIsEmpty = false
                    print("following list is not empty")
                }
            } else {
                // Handle the case where currentUser is nil
                followingListIsEmpty = true
                print("currentUser is nil")
            }
        }


    }
    
    private func getRecentQuills() -> [Quill] {
        // Calculate the date one week ago from the current date
        let oneWeekAgo = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date()) ?? Date()

        // Filter quills posted in the past week
        let recentQuills = quillViewModel.quills
            .filter { quill in
                return quill.postedDateTime > oneWeekAgo
            }
            .sorted(by: { $0.postedDateTime > $1.postedDateTime })

        return recentQuills
    }


    private func getFollowingQuills() -> [Quill] {
        let currentUserID = authViewModel.currentUser?.id
        return quillViewModel.quills
            .filter { quill in
                let isFollowing = userViewModel.userIsFollowed(currentUserID: currentUserID ?? "", otherUserID: quill.user.id)
                return isFollowing
            }
            .sorted(by: { $0.postedDateTime > $1.postedDateTime })
    }
    
    private func getDiscoverQuills() -> [Quill] {
        guard let currentUserID = authViewModel.currentUser?.id else {
            return []
        }

        // Get the users that the current user is following
        guard let currentUser = userViewModel.users.first(where: { $0.id == currentUserID }) else {
            return []
        }

        let usersIFollow = Set(currentUser.following)

        // Get the users followed by the current user's following users
        let usersFollowedByIFollow = Set(userViewModel.users
            .filter { user in usersIFollow.contains(user.id) }
            .flatMap { $0.following })

        // Filter quills from users who are followed by the current user's following users
        let suggestedQuills = quillViewModel.quills
            .filter { quill in
                let quillUserID = quill.user.id
                // Check if the quill user is followed by the users that the current user follows
                return usersFollowedByIFollow.contains(quillUserID)
            }
            .sorted(by: { $0.postedDateTime > $1.postedDateTime })

        return suggestedQuills
    }



}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(quillViewModel: QuillViewModel())
            .environmentObject(AuthViewModel())
            .environmentObject(UserViewModel())
    }
}
