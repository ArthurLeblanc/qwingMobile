//
//  UserViewModel.swift
//  ProjetV0
//
//  Created by Anthony Partinico on 08/03/2020.
//  Copyright © 2020 user164566. All rights reserved.
//

import Foundation

class UserViewModel : ObservableObject {
    
    @Published var loggedUser : Utilisateur? = nil
    init(email : String, password : String) {
        self.loggedUser = WebService().login(email : email, password : password)
    }
    
    init(email : String, pseudo : String, password : String) {
        self.loggedUser = WebService().signup(email: email, pseudo: pseudo, password: password)
    }
    
}
