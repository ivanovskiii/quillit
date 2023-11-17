//
//  AuthViewModel.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 16.11.23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Firebase

@MainActor
class AuthViewModel: ObservableObject{
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init(){
        self.userSession = Auth.auth().currentUser
        
        Task{
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws{
        do{
            
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch{
            print("Failed to sign in user \(error.localizedDescription)")
        }
    }
        
    func createAccount(username: String, withEmail email: String, password: String, followers: [User], following: [User]) async throws{
        do{
            
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            let user = User(id: result.user.uid, username: username, email: email, followers: followers, following: following)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("user").document(user.id).setData(encodedUser)
            self.userSession = result.user
            await fetchUser()
        } catch{
            
                print("Failed to create user \(error.localizedDescription)")
            print("Failed to create user \(error.self)")
            
            }
        }
        
        func signOut(){
            do{
                
                try Auth.auth().signOut()
                self.userSession = nil
                self.currentUser = nil
                
            } catch{
                
                print("Error sign out \(error.localizedDescription)")
                
            }
        }
        
        func fetchUser() async{
            guard let uid = Auth.auth().currentUser?.uid else { return }
            guard let snapshot = try? await Firestore.firestore().collection("user").document(uid).getDocument() else { return }
            self.currentUser = try? snapshot.data(as: User.self)
            
            print("DEBUG: Current user fetched is: \(String(describing: self.currentUser))")
        }
        
}
