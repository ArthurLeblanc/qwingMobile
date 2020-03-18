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
    @State var showingAlert = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("proposé par - \(self.reponse.createur?.pseudo ?? "Anonyme")")
                    .font(.caption)
                    .padding([.top, .leading])
                Spacer()
                if (self.session != nil && self.session?.email == reponse.createur?.email) {
                    Image(systemName: "hand.thumbsup").padding(.bottom).onTapGesture {
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
                //Text("Voir les réponses >").font(.caption).padding([.leading, .bottom])

                Spacer()
                Image(systemName: "hand.thumbsdown").padding(.bottom)
                Text(String(self.reponse.dislikes))
                    .font(.caption)
                    .padding([.bottom, .trailing])
                Image(systemName: "hand.thumbsup").padding(.bottom)
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
