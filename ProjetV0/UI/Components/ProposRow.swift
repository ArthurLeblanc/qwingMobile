//
//  ProposRow.swift
//  ProjetV0
//
//  Created by user164566 on 3/8/20.
//  Copyright © 2020 user164566. All rights reserved.
//

import SwiftUI

struct ProposRow: View {
    var propos: Propos
    @State var liked: Bool
    var session : Utilisateur?
    @State private var showingAlert = false
    @State private var showingAlert2 = false
    @EnvironmentObject var proposListe : ProposListeViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("proposé par - \(propos.createur?.pseudo ?? "Anonyme") - ")
                    .font(.caption)
                    .padding([.top, .leading])
                Text("\(propos.categorie)")
                    .font(.caption).bold()
                    .padding(.top)
                Spacer()
                if (self.session != nil && self.session?.email == propos.createur?.email) {
                    Image(systemName: "trash").foregroundColor(Color.red).padding(.bottom).onTapGesture {
                        WebService().deletePropos(propos: self.propos, createur: self.session!)
                        if let index = self.proposListe.proposListe.firstIndex(where: {$0.idC == self.propos.idC}) {
                            self.proposListe.proposListe.remove(at: index)
                        }
                        //self.showingAlert2.toggle()
                    }.alert(isPresented: $showingAlert2) {
                        Alert(title: Text("Information"), message: Text("Propos supprimé"), dismissButton: .default(Text("Ok")))
                    }.padding([.top, .trailing])
                }
            }
            Text(self.propos.contenu)
                .font(.headline)
                .padding(.all)
                .frame(height: 75.0)
            HStack {
                Text("Créé le : \(propos.date)").font(.caption).padding([.leading, .bottom])
                Spacer()
                if (self.session == nil) {
                    Image(systemName: "ear").padding(.bottom).onTapGesture {
                        self.showingAlert.toggle()
                    }.alert(isPresented: $showingAlert) {
                        Alert(title: Text("Information"), message: Text("Vous devez vous connecter pour aimer un propos !"), dismissButton: .default(Text("J'ai compris !")))
                    }
                } else {
                    Image(systemName: self.liked ? "hand.thumbsup.fill" : "hand.thumbsup").padding(.bottom).onTapGesture {
                        if (self.liked) {
                            self.session!.dislikePropos(propos: self.propos)
                            self.propos.likes -= 1
                        } else {
                            self.session!.likePropos(propos: self.propos)
                            self.propos.likes += 1
                        }
                        self.liked.toggle()
                    }
                }

                Text(String(self.propos.likes))
                    .font(.caption)
                    .padding([.bottom, .trailing])
            }
        }.border(Color(red: 0.933, green: 0.412, blue: 0.247), width: 1).padding()
    }
}

/*
struct ProposRow_Previews: PreviewProvider {
    static var previews: some View {
        ProposRow(propos: $proposListe)
    }
}
*/
