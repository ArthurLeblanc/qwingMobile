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
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("proposé par - \(propos.createur?.pseudo ?? "Anonyme")")
                .font(.caption)
                .padding([.top, .leading])
            Text(self.propos.contenu)
                .font(.headline)
                .padding(.all)
                .frame(height: 75.0)
            HStack {
                //Text("Voir les réponses >").font(.caption).padding([.leading, .bottom])
                Spacer()
                if (self.session == nil) {
                    Image(systemName: "hand.thumbsup").padding(.bottom).onTapGesture {
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
