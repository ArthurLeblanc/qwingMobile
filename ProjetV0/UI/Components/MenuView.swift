//
//  MenuView.swift
//  ProjetV0
//
//  Created by Anthony Partinico on 29/02/2020.
//  Copyright © 2020 user164566. All rights reserved.
//

import SwiftUI

struct MenuView: View {
    
    @Binding var session : Utilisateur?
    @Binding var showMenu : Bool
    @Environment(\.presentationMode) var presentationMode
    
    
    var whoIsActive : String
    
    func logged() -> Row {
        if ((self.session) != nil) {
            return Row(rowActive: false, icon: "arrow.uturn.left", text: "Se déconnecter")
        }
        return Row(rowActive: whoIsActive == "Connexion", icon: "arrow.uturn.right", text: "Se connecter")
        
    }
    
    var body: some View {
        
        VStack() {
            HStack {
                Image(systemName: "gear")
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .heavy))
                    .frame(width: 32, height: 32)
                ZStack {
                    Image("pepe")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .padding(.horizontal, 24)
                    Circle()
                        .stroke(Color(red: 0.059, green: 0.488, blue: 0.939))
                        .frame(width: 70, height: 70)
                        .offset(x: -2, y: -1)
                    
                    Circle()
                        .stroke(Color(red: 0.933, green: 0.412, blue: 0.247))
                        .frame(width: 70, height: 70)
                        .offset(x: -2, y: -1)
                    
                }
                if (self.session != nil) {
                    NavigationLink(destination: MonCompte(session: self.$session)) {
                        Image(systemName: "pencil")
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .heavy))
                            .frame(width: 32, height: 32)
                    }
                }
                
                
            }.padding(.top, 90)
            
            Text(self.session?.pseudo ?? "Anonyme")
                /*.foregroundColor(.white)
                .font(.system(size: 20, weight: .semibold))
                .padding(.top, 10)
                .padding(.bottom, 40)*/
            
            
            NavigationLink(destination: Accueil()) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                    self.showMenu.toggle()
                }) {
                    Row(rowActive: self.whoIsActive == "Accueil", icon: "house", text: "Accueil")                }
            }
            //Text("Utilisateur").font(.largeTitle).padding(.leading, -30).foregroundColor(.white)
            
            NavigationLink(destination: AjoutPropos(session: self.$session)) {
                
                Row(rowActive: whoIsActive == "Ajouter un propos", icon: "plus.circle", text: "Ajouter Propos")
            }
            NavigationLink(destination: ProposUser(session: self.session)) {
                Row(rowActive: false, icon: "rectangle.grid.1x2", text: "Mes propos")
            }
            Row(rowActive: false, icon: "plus.circle", text: "Mes réponses")
<<<<<<< HEAD
=======
            
>>>>>>> 0679bf318ef2c5fc448fe06c82c65911663a299a
            NavigationLink(destination: ProposLiked(session: self.session)) {
                Row(rowActive: false, icon: "heart", text: "Mes propos entendus")
            }
            
            Spacer()
            if (self.session != nil) {
                NavigationLink(destination: Accueil()) {
                    logged()
                }
            } else {
                NavigationLink(destination: Login(session: self.$session)) {
                    logged()
                    
                }
            }
            
        }     .padding(.vertical, 30)
            .background(LinearGradient(gradient: Gradient(colors: [.blue, .orange]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .padding(.trailing, 80)
            .frame(maxWidth: .infinity, alignment: .leading)
            .edgesIgnoringSafeArea(.all)
        
        
    }
}

struct Row: View {
    var rowActive: Bool
    var icon = "house"
    var text = "Dashboard"
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(rowActive ? Color(red: 0.059, green: 0.488, blue: 0.939, opacity: 1.0) : .white)
                .font(.system(size: 15, weight: rowActive ? .bold : .regular))
                .frame(width: 48, height: 32)
            
            Text(text)
                .font(.system(size: 15, weight: rowActive ? .bold : .regular))
                .foregroundColor(rowActive ? Color(red: 0.059, green: 0.488, blue: 0.939, opacity: 1.0) : .white)
            
            Spacer()
            
        }
        .padding(4)
        .background(rowActive ? Color.white : Color.white.opacity(0))
        .padding(.trailing, 20)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .offset(x: 20)
    }
}
/*
 struct MenuView_Previews: PreviewProvider {
 static var previews: some View {
 MenuView()
 }
 }
 */
