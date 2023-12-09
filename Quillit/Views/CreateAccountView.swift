//
//  CreateAccountView.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 16.11.23.
//

import SwiftUI

struct CreateAccountView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var username = ""
    @State var password = ""
    @State var email = ""
    
    var body: some View {
        VStack(alignment: .center){
            Spacer()
            
            Text("Create Account")
                .font(Font.custom("Ahsing", size: 30))
                .foregroundStyle(Color("QBlack"))
            
            Spacer()
            TextField("Username", text: $username, prompt:
                        Text("Username"))
            .autocorrectionDisabled(true)
            .font(Font.custom("SpaceMono-Regular", size: 18))
            .textInputAutocapitalization(.never)
            .padding(10)
            .frame(height: 40)
            .overlay{
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("QBlack"), lineWidth: 1)
            }
            .padding(.horizontal)
            
            TextField("Email", text: $email, prompt:
                        Text("Email"))
            .autocorrectionDisabled(true)
            .font(Font.custom("SpaceMono-Regular", size: 18))
            .textInputAutocapitalization(.never)
            .padding(10)
            .frame(height: 40)
            .overlay{
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("QBlack"), lineWidth: 1)
            }
            .padding(.horizontal)
            
            SecureField("Password", text: $password, prompt:
                            Text("Password"))
            .autocorrectionDisabled(true)
            .font(Font.custom("SpaceMono-Regular", size: 18))
            .textInputAutocapitalization(.never)
            .padding(10)
            .frame(height: 40)
            .overlay{
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("QBlack"), lineWidth: 1)
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button{
                Task{
                    try await authViewModel.createAccount(username: username, withEmail: email, password: password, followers: [], following: [])
                }
            } label: {
                Text("Create Account")
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

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
            .environmentObject(AuthViewModel())
    }
}
