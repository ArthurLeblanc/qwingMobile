//
//  Inscription.swift
//  ProjetV0
//
//  Created by user164566 on 2/28/20.
//  Copyright © 2020 user164566. All rights reserved.
//


import SwiftUI

enum AlertActive {
    case first, second, third, fourth
}

struct Inscription: View {
    //Pour faire un retour une fois qu'on a appuyé sur un bouton
    @Environment(\.presentationMode) var presentationMode
    
    @State var pseudo : String = ""
    @State var password : String = ""
    @State var confirmpassword : String = ""
    @State var email : String = ""
    @State var showAlert : Bool = false
    @State var activeAlert: AlertActive = .first    //admin .??
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .frame(width: 150.0, height: 145.0)
                .scaledToFit()
            Spacer()
            Text ("Inscription")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.bottom, 20)
            Spacer()
            
            TextField("Email : ", text : $email).padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            TextField("Pseudo : ", text: $pseudo).padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            SecureField("Mot de passe : ", text : $password).padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            SecureField("Confirmation mot de passe : ", text : $confirmpassword).padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            
            NavigationLink(destination : Accueil(session: Utilisateur(pseudo: self.pseudo, email: self.email, password: self.password))) {
                Button(action: {
                    if !self.isValidEmail(email: self.email){
                        self.showAlert.toggle()
                        self.activeAlert = .first
                    }
                    else if self.pseudo == ""{
                        self.showAlert.toggle()
                        self.activeAlert = .second
                    }
                    else if self.password != self.confirmpassword {
                        self.showAlert.toggle()
                        self.activeAlert = .fourth
                    }
                    else if self.password.count < 6 {
                        self.showAlert.toggle()
                        self.activeAlert = .third
                    }
                    else{
                        let userViewModel : UserViewModel = UserViewModel(email : self.email, pseudo : self.pseudo, password : self.password)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("S'inscrire")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color.blue)
                        .cornerRadius(15.0)
                }.alert(isPresented: $showAlert) {
                    switch activeAlert {
                    case .first:
                        return Alert(title: Text("Information"), message: Text("Votre adresse mail n'est pas valide !"), dismissButton: .default(Text("J'ai compris !")))
                    case .second:
                        return Alert(title: Text("Information"), message: Text("Votre pseudo ne peut pas être vide !"), dismissButton: .default(Text("J'ai compris !")))
                    case .third :
                        return Alert(title: Text("Information"), message: Text("Votre mot de passe doit faire au moins 6 caractères !"),
                                     dismissButton: .default(Text("J'ai compris !")))
                    case .fourth :
                        return Alert(title: Text("Information"), message: Text("Le mot de passe ne coïncide pas avec la confirmation !"),
                                     dismissButton: .default(Text("J'ai compris !")))
                    }
                }
            }
        }            .padding(.horizontal, 30.0)
        
    }
}

/*
 struct Inscription_Previews: PreviewProvider {
 static var previews: some View {
 Inscription()
 }
 }
 */
