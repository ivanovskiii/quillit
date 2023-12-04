//
//  ContentView.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 15.11.23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var notificationViewModel = NotificationViewModel()
    @StateObject private var userViewModel = UserViewModel()

    var body: some View {
        Group{
            if authViewModel.userSession !=  nil{
                MainView()
                    .environmentObject(notificationViewModel)
                    .environmentObject(userViewModel)
            } else {
                LoginView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}
