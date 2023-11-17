//
//  LoginView.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 16.11.23.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .center){
                Spacer()
                Image("quillit-logo-black")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 180.0)
                Spacer()
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
                        try await authViewModel.signIn(withEmail: email, password: password)
                    }
                } label: {
                    Text("Login")
                        .font(Font.custom("SpaceMono-Regular", size: 18))
                        .foregroundColor(Color.white)
                        .frame(height: 45)
                        .frame(maxWidth: .infinity)
                        .background(Color("QBlack"))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                NavigationLink{
                   CreateAccountView()
                } label: {
                    Text("Create Account")
                        .font(Font.custom("SpaceMono-Regular", size: 18))
                        .foregroundColor(Color("QBlack"))
                        .frame(height: 45)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                        .overlay{
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("QBlack"), lineWidth: 2)
                        }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModel())
            .tint(Color("QBlack"))
    }
}
