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
                Text("👥 Following").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            ScrollView {
                switch selectedTab {
                case 0:
                    // Display all quills
                    ForEach(quillViewModel.quills.sorted(by: { $0.postedDateTime > $1.postedDateTime })) { quill in
                        QuillCardView(quill: quill)
                            .padding(.bottom, 5)
                    }
                case 1:
                    // Display quills from users you follow
                    ForEach(getFilteredQuills()) { quill in
                        QuillCardView(quill: quill)
                            .padding(.bottom, 5)
                    }
                default:
                    EmptyView()
                }
            }
        }
    }

    private func getFilteredQuills() -> [Quill] {
        let currentUserID = authViewModel.currentUser?.id
        return quillViewModel.quills
            .filter { quill in
                let isFollowing = userViewModel.userIsFollowed(currentUserID: currentUserID ?? "", otherUserID: quill.user.id)
                return isFollowing
            }
            .sorted(by: { $0.postedDateTime > $1.postedDateTime })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(quillViewModel: QuillViewModel())
            .environmentObject(AuthViewModel())
            .environmentObject(UserViewModel())
    }
}
