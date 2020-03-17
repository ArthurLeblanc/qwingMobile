//
//  MonCompte.swift
//  ProjetV0
//
//  Created by user164566 on 2/28/20.
//  Copyright © 2020 user164566. All rights reserved.
//

import SwiftUI
import Foundation

struct MonCompte: View {
    
    @State var session : Utilisateur
    //Pour faire un retour une fois qu'on a appuyé sur un bouton
    @Environment(\.presentationMode) var presentationMode
    
    @State var pseudo : String = ""
    @State var password : String = ""
    @State var confirmpassword : String = ""
    
    @State var email : String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Image("logo")
                    .resizable()
                    .frame(width: 150.0, height: 145.0)
                    .scaledToFit()
                Spacer()
                Text ("Mon Compte")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom, 20)
                Spacer()
                TextField("Adresse email : ", text : $email)                    .onAppear {
                    self.email = self.session.email
                }
                .padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                TextField("Pseudo : ", text: $pseudo)
                    .onAppear {
                        self.pseudo = self.session.pseudo
                }
                .padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                SecureField("Mot de passe: ", text : $password)
                    .onAppear {
                        self.password = self.session.password
                }
                .padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                SecureField(" Confirmation mot de passe : ", text : $confirmpassword)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                Spacer()
                NavigationLink(destination : Accueil(session: self.session)) {
                    Button(action: {
                        self.session = Utilisateur(pseudo: self.pseudo, email: self.email, password: self.password)
                        print(self.session)
                        self.presentationMode.wrappedValue.dismiss()
                        
                    }) {
                        Text("Modifier")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(Color.blue)
                            .cornerRadius(15.0)
                    }
                }
            }.padding(.horizontal, 30.0)
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
