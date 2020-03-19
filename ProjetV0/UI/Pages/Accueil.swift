//
//  Accueil.swift
//  ProjetV0
//
//  Created by user164566 on 2/16/20.
//  Copyright © 2020 user164566. All rights reserved.
//

import SwiftUI

struct Accueil: View {
    
    @EnvironmentObject var proposListe : ProposListeViewModel
    @State var session : Utilisateur?
    @State var showMenu = false
    @Environment(\.presentationMode) var presentationMode
    
    func phraseBienvenue() -> some View {
        if let session = self.session {
            return Text("Vous êtes connecté en tant que (pseudo) : " + session.pseudo )
        } else {
            return Text("Vous êtes connecté anonymement")
                .foregroundColor(Color(red: 0.02, green: 0.153, blue: 0.208))
        }
        
    }
    
    
    var body: some View {
        // Bleu : 5, 39, 53
        // Orange : 238, 105, 63
        
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation {
                        self.showMenu = false
                    }
                }
        }
        
        return NavigationView {
            GeometryReader { geometry in
                ZStack {
                    NavigationView {
                        VStack {
                            Image("logo").resizable().frame(width: 150.0, height: 145.0).scaledToFit()
                            self.phraseBienvenue()
                            Text("A propos").foregroundColor(Color(red: 0.933, green: 0.412, blue: 0.247)).bold().padding(10.0).multilineTextAlignment(.leading)
                            
                            Text("Vous avez été victime d'un propos sexiste et vous n'avez pas su répondre ? Partagez votre expérience")
                                .fontWeight(.light)
                                .padding(2.0)
                                .foregroundColor(Color(red: 0.02, green: 0.153, blue: 0.208))
                            NavigationLink(destination : AjoutPropos(session : self.$session)) {
                                Text ("Ajouter un propos")
                                    .foregroundColor(Color(red: 0.933, green: 0.412, blue: 0.247))
                            }
                            .padding(.top, 20.0)
                            .padding(.bottom, 15.0)
                            
                            Text("Les plus populaires")
                                .font(.headline).foregroundColor(Color(red: 0.02, green: 0.153, blue: 0.208))
                            Divider()
                            List {
                                ForEach (self.proposListe.proposListe) {
                                    p in
                                    NavigationLink(destination : ProposDetail(session: self.session, contenu: p)) {
                                        ProposRow(propos: p, liked: p.isLiked(user: self.session), session: self.session)
                                    }
                                }
                            }
                        }.padding(.top, -80)
                    }.navigationViewStyle(StackNavigationViewStyle())
                    
                    if self.showMenu {
                        MenuView(session: self.$session, showMenu: self.$showMenu, whoIsActive: "Accueil")
                            .transition(.move(edge: .leading))
                    }
                }
                .gesture(drag)
            }
            .navigationBarTitle("Accueil", displayMode: .inline)
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
        }.navigationViewStyle(StackNavigationViewStyle())
    }

}
/*
 struct Accueil_Previews: PreviewProvider {
 static var previews: some View {
 //Accueil( session: Utilisateur(pseudo: "pseudo", email: "email", password: "pass", isAdmin: true, ville: "Montpellier"), listeBD: UtilisateurListe())
 Accueil(session: Utilisateur(pseudo: "a", email: "a", password: "a"))
 }
 }
 
 */
