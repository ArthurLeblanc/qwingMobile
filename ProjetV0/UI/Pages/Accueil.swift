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
    @State var recherche : String = ""
    @State var proposToShow : [Propos]  = []
    @Environment(\.presentationMode) var presentationMode
    
    func phraseBienvenue() -> some View {
        if let session = self.session {
            return Text("Vous êtes connecté en tant que : " + session.pseudo )
        } else {
            return Text("Vous êtes connecté anonymement")
                .foregroundColor(Color(red: 0.02, green: 0.153, blue: 0.208))
        }
        
    }
    
    func rechercheNulle() {
        self.proposToShow.removeAll()
        self.proposToShow.append(contentsOf: self.proposListe.proposListe)
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
        
        DispatchQueue.main.async {
        var i : Int = 0
           self.rechercheNulle()
               if (self.recherche != ""){
           while (i < self.proposToShow.count) {
               if(!(self.proposToShow[i].contenu.lowercased().contains(self.recherche.lowercased()))){
                   self.proposToShow.remove(at: i)
               }
               else {
               i = i+1
               }
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
                            TextField("Rechercher", text: self.$recherche)
                            .padding()
                            .background(lightGreyColor)
                            .cornerRadius(5.0)
                            .padding(.horizontal, 20)
                            List {
                                ForEach (self.proposToShow) {
                                    p in
                                    NavigationLink(destination : ProposDetail(session: self.session, contenu: p, reponses: p.reponses, commentaires: p.commentaires)) {
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
