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
    @State var showContextMenu = false
    
    var body: some View {
        VStack{
            HStack{
                Text("\(authViewModel.currentUser?.username ?? "username")")
                    .font(Font.custom("Ahsing", size: 25))
                Image(systemName: "gearshape")
                    .font(Font.custom("SpaceMono-Regular", size: 18))
                    .onTapGesture {
                        showContextMenu = true
                    }
                    .confirmationDialog("Options", isPresented: $showContextMenu, titleVisibility: .visible){
                        Button("Log Out from @\(authViewModel.currentUser?.username ?? "username")", role: .destructive){
                            authViewModel.signOut()
                        }
                    }
            }
            
            
            ScrollView {
                Circle()
                    .frame(width: 100)
                HStack (spacing: 60) {
                    Text("Followers: \(authViewModel.currentUser?.followers.count ?? 0)")
                        .font(Font.custom("SpaceMono-Regular", size: 15))
                    Text("Following: \(authViewModel.currentUser?.following.count ?? 0)")
                        .font(Font.custom("SpaceMono-Regular", size: 15))
                }
                
                ForEach(quillViewModel.quills.sorted(by: { $0.postedDateTime > $1.postedDateTime })) { quill in
                    if authViewModel.currentUser?.id == quill.user.id {
                        QuillCardView(quill: quill)
                            .padding(.bottom, 5)
                    }
                }
            }
            
            Spacer()
            
            //            Button{
            //                authViewModel.signOut()
            //            } label: {
            //                Text("Sign Out")
            //                    .font(Font.custom("SpaceMono-Regular", size: 18))
            //                    .foregroundColor(Color.white)
            //                    .frame(height: 45)
            //                    .frame(maxWidth: .infinity)
            //                    .background(Color("QBlack"))
            //                    .cornerRadius(10)
            //            }
            //            .padding(.horizontal)
            //            .padding(.bottom, 30)
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(quillViewModel: QuillViewModel())
            .environmentObject(AuthViewModel())
    }
}
