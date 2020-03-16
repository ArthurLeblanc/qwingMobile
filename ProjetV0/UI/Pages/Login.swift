//
//  Login.swift
//  ProjetV0
//
//  Created by user164566 on 2/28/20.
//  Copyright © 2020 user164566. All rights reserved.
//

import SwiftUI

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)

struct Login: View {
    
    //let utilisateurs: [Utilisateur] = [Utilisateur(pseudo: "lauren", email: "lauren", password: "lauren", isAdmin: true, ville: "Montpellier")]
    
    //Pour faire un retour une fois qu'on a appuyé sur un bouton
    //Environment(\.presentationMode) var presentationMode
    
    @State var mail : String = ""
    @State var password : String = ""
    @State var showMenu = false
    @Binding var session : Utilisateur?

    var body: some View {
        
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation {
                        self.showMenu = false
                    }
                }
        }
        
        return
            GeometryReader { geometry in
                ZStack(alignment : .leading) {
                    NavigationView {
                        VStack {
                            WelcomeText()
                            TextField("Adresse mail", text: self.$mail)
                                .padding()
                                .background(lightGreyColor)
                                .cornerRadius(5.0)
                                .padding(.bottom, 20)
                            SecureField("Mot de passe", text: self.$password)
                                .padding()
                                .background(lightGreyColor)
                                .cornerRadius(5.0)
                                .padding(.bottom, 20)
                            NavigationLink(destination : Accueil()) {
                                Button(action: {
                                    let userViewModel : UserViewModel = UserViewModel(email : self.mail, password : self.password)
                                    if userViewModel.loggedUser != nil {
                                        self.session = userViewModel.loggedUser!
                                        print("pseudo de l'utilisateur connecté : \(self.session!.pseudo)")
                                        //self.presentationMode.wrappedValue.dismiss()
                                        
                                    }
                                    /* A MODIFIER */
                                    /*if (self.listeBD.estUtilisateur(mail : self.mail, password : self.password)) {
                                     self.session = self.listeBD.getUtilisateur (mail : self.mail, password : self.password)
                                     self.session.log()
                                     self.presentationMode.wrappedValue.dismiss()
                                     }
                                     else {
                                     Text("Ce n est pas le bon identifiant ! Le bon login est \"\" et le bon mdp est \"\" ")
                                     }*/
                                    
                                }) {
                                    LoginButtonContent()
                                }
                                .padding(.top, 5.0)
                            }
                            NavigationLink(destination : Inscription()){
                                
                                Text("S'inscrire")
                                
                            }
                            .padding(.top, 10.0)
                            
                        }.padding(.horizontal, 30.0)
                        
                        
                    }.navigationViewStyle(StackNavigationViewStyle())
                    if self.showMenu {
                        MenuView(session: self.$session, showMenu: self.$showMenu, whoIsActive: "Connexion")
                            .transition(.move(edge: .leading))
                    }
                }
                .gesture(drag)
            }
            .navigationBarTitle("Connexion", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: (
                Button(action: {
                    withAnimation {
                        self.showMenu.toggle()
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .imageScale(.large)
                }
            ))
    }
    
}

struct Login_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct WelcomeText : View {
    var body: some View {
        return Text("Connexion")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}

struct LoginButtonContent : View {
    var body: some View {
        return Text("Se connecter")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.blue)
            .cornerRadius(15.0)
    }
}

