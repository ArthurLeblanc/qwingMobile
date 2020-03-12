//
//  Inscription.swift
//  ProjetV0
//
//  Created by user164566 on 2/28/20.
//  Copyright © 2020 user164566. All rights reserved.
//


import SwiftUI

struct Inscription: View {
    //Pour faire un retour une fois qu'on a appuyé sur un bouton
    @Environment(\.presentationMode) var presentationMode
    
    @State var pseudo : String = ""
    @State var password : String = ""
    @State var email : String = ""
    //admin .??
    
    var body: some View {
        NavigationView {
            VStack {
                Text ("Connexion")
                Spacer()
                Form {
                    TextField("Pseudo : ", text: $pseudo)
                    TextField("Password : ", text : $password)
                    TextField("Email : ", text : $email)
                    
                }
                NavigationLink(destination : Accueil(session: Utilisateur(pseudo: self.pseudo, email: self.email, password: self.password))) {
                    Button(action: {
                        let userViewModel : UserViewModel = UserViewModel(email : self.email, pseudo : self.pseudo, password : self.password)
                    }) {
                    Text("S'inscrire")
                    }
                }
            }
        }
    }
}

/*
struct Inscription_Previews: PreviewProvider {
    static var previews: some View {
        Inscription()
    }
}
*/
