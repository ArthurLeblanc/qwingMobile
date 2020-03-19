//
//  ReponseRow.swift
//  ProjetV0
//
//  Created by user164566 on 3/9/20.
//  Copyright © 2020 user164566. All rights reserved.
//

import SwiftUI

struct ReponseRow: View {
    var reponse: Reponse
    var session : Utilisateur?
    @State var liked: Bool
    @State var disliked: Bool
    @State var showingAlert = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("proposé par - \(self.reponse.createur?.pseudo ?? "Anonyme") -")
                    .font(.caption)
                    .padding([.top, .leading])
                Text("\(self.reponse.categorie)")
                    .font(.caption).bold()
                    .padding(.top)
                Spacer()
                if (self.session != nil && self.session?.email == reponse.createur?.email) {
                    Image(systemName: "trash").padding(.bottom).onTapGesture {
                        WebService().deleteReponse(reponse: self.reponse, createur: self.session!)
                        self.showingAlert.toggle()
                    }.alert(isPresented: $showingAlert) {
                        Alert(title: Text("Information"), message: Text("Réponse supprimée"), dismissButton: .default(Text("Ok")))
                    }.padding([.top, .trailing])
                }
            }
            
            Text(self.reponse.contenu)
                .font(.headline)
                .padding(.all)
            HStack {
                Text("Créé le : \(reponse.date)").font(.caption).padding([.leading, .bottom])
                
                Spacer()
                if (self.session == nil) {
                    Image(systemName: "hand.thumbsup").padding(.bottom).onTapGesture {
                        self.showingAlert.toggle()
                    }.alert(isPresented: $showingAlert) {
                        Alert(title: Text("Information"), message: Text("Vous devez vous connecter pour aimer un propos !"), dismissButton: .default(Text("J'ai compris !")))
                    }
                } else {
                    Image(systemName: self.disliked ? "hand.thumbsdown.fill" : "hand.thumbsdown").padding(.bottom).onTapGesture {
                        if (self.disliked) {
                            self.session!.undislikeReponse(reponse: self.reponse)
                            self.reponse.dislikes -= 1
                        } else {
                            self.session!.dislikeReponse(reponse: self.reponse)
                            self.reponse.dislikes += 1
                            if (self.liked) {
                                self.reponse.likes -= 1
                                self.liked.toggle()
                            }
                        }
                        self.disliked.toggle()
                    }
                    Text(String(self.reponse.dislikes))
                        .font(.caption)
                        .padding([.bottom, .trailing])
                    Image(systemName: self.liked ? "hand.thumbsup.fill" : "hand.thumbsup").padding(.bottom).onTapGesture {
                        if (self.liked) {
                            self.session!.unlikeReponse(reponse: self.reponse)
                            self.reponse.likes -= 1
                        } else {
                            self.session!.likeReponse(reponse: self.reponse)
                            self.reponse.likes += 1
                            if (self.disliked) {
                                self.reponse.dislikes -= 1
                                self.disliked.toggle()
                            }
                        }
                        self.liked.toggle()
                    }
                }
                Text(String(self.reponse.likes))
                    .font(.caption)
                    .padding([.bottom, .trailing])
            }
        }.border(Color.gray, width: 1).padding()
    }
}
/*
 struct ReponseRow_Previews: PreviewProvider {
 static var previews: some View {
 ReponseRow()
 }
 }
 */
