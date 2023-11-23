//
//  SearchView.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 15.11.23.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var userViewModel: UserViewModel
    @State private var searchText = ""
    
    var currentUserID: String? {
            authViewModel.currentUser?.id
        }

    var filteredUsers: [User] {
        return userViewModel.users.filter { user in
            user.id != currentUserID && user.username.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Text("Search")
                    .font(Font.custom("Ahsing", size: 25))
                
                TextField("Search username", text: $searchText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .frame(height: 60)
                    .font(Font.custom("SpaceMono-Regular", size: 15))

                List(filteredUsers) { user in
                    NavigationLink(destination: ProfileView(quillViewModel: QuillViewModel(), userViewModel: UserViewModel(), user: user)) {
                        HStack {
                            Text("@\(user.username)")
                                .font(Font.custom("SpaceMono-Regular", size: 15))
                            Spacer()
                        }
                        .padding()
                    }
                }
    //            .listStyle(PlainListStyle())
                
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(userViewModel: UserViewModel())
            .environmentObject(AuthViewModel())
    }
}
