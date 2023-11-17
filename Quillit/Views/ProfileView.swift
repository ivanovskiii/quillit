//
//  ProfileView.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 15.11.23.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack{
            Text("\(authViewModel.currentUser?.username ?? "username")")
                .font(Font.custom("Ahsing", size: 25))
            
            Spacer()
            
            Button{
                authViewModel.signOut()
            } label: {
                Text("Sign Out")
                    .font(Font.custom("SpaceMono-Regular", size: 18))
                    .foregroundColor(Color.white)
                    .frame(height: 45)
                    .frame(maxWidth: .infinity)
                    .background(Color("QBlack"))
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthViewModel())
    }
}
