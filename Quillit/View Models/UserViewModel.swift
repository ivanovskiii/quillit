//
//  UserViewModel.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 21.11.23.
//

import Foundation
import UIKit
import SwiftUI
import Combine

@MainActor
class UserViewModel: ObservableObject{
    
    @Published var userRepository = UserRepository()
    @Published var users: [User] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(){
        userRepository.$users
            .assign(to: \.users, on: self)
            .store(in: &cancellables)
    }
}
