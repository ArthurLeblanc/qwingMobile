//
//  MonCompte.swift
//  ProjetV0
//
//  Created by user164566 on 2/28/20.
//  Copyright © 2020 user164566. All rights reserved.
//

import SwiftUI
import Foundation

enum ActiveAlert {
    case first, second, third
}


struct MonCompte: View {
    
    @Binding var session : Utilisateur?
    //Pour faire un retour une fois qu'on a appuyé sur un bouton
    @Environment(\.presentationMode) var presentationMode
    
    @State var pseudo : String = ""
    @State var password : String = ""
    @State var confirmpassword : String = ""
    
    @State var email : String = ""
    @State var showAlert: Bool = false
    @State var activeAlert: ActiveAlert = .first
    
    
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
                    self.email = self.session!.email
                }
                .disabled(true)
                .padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                TextField("Pseudo : ", text: $pseudo)
                    .onAppear {
                        self.pseudo = self.session!.pseudo
                }
                .padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                SecureField("Mot de passe: ", text : $password)
                    .onAppear {
                        self.password = self.session!.password
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
                /*NavigationLink(destination : Accueil(session: nil)){
                    Button(action: {
                        UserViewModel().deleteAccount(email: self.email)
                    }) {
                        Text("Supprimer mon compte").foregroundColor(Color.red)
                    }
                }*/
                NavigationLink(destination : Accueil(session: self.session)) {
                    Button(action: {
                        if self.password != self.confirmpassword {
                            self.showAlert.toggle()
                            self.activeAlert = .first
                        }
                        else if self.password.count < 6 {
                            self.showAlert.toggle()
                            self.activeAlert = .second
                            
                        }
                        else if self.pseudo.count == 0 {
                            self.showAlert.toggle()
                            self.activeAlert = .third
                        }
                        else {
                            self.session!.pseudo = self.pseudo
                            self.session!.email =  self.email
                            self.session!.password = self.password
                            UserViewModel().updateAccount(email : self.email, pseudo : self.pseudo, password : self.password)
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Modifier")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(Color.blue)
                            .cornerRadius(15.0)
                    }.alert(isPresented: $showAlert) {
                        switch activeAlert {
                        case .first:
                            return Alert(title: Text("Information"), message: Text("Le mot de passe ne coïncide pas avec la confirmation !"), dismissButton: .default(Text("J'ai compris !")))
                        case .second:
                            return Alert(title: Text("Information"), message: Text("Votre mot de passe doit faire au moins 6 caractères !"), dismissButton: .default(Text("J'ai compris !")))
                        case .third :
                            return Alert(title: Text("Information"), message: Text("Votre pseudo ne peut pas être vide !"),
                                         dismissButton: .default(Text("J'ai compris !")))
                        }
                    }
                }
                
            }
            .padding(.horizontal, 30.0)
            
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
