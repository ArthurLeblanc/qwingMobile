//
//  ContentView.swift
//  ProjetV0
//
//  Created by user164566 on 2/16/20.
//  Copyright © 2020 user164566. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var proposList = ProposListeViewModel()
    
    
    init() {
        UITableView.appearance().separatorColor = .clear
    }
    
    var body: some View {
        Text("AZccueil")
        /*
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(self.postCreator(c : p))
                    .fontWeight(.bold)
                Spacer()
                Text(self.formatter.string(from: p.date))
                    .foregroundColor(Color.gray)
            }
            .padding()
            
            Text(p.contenu)
            HStack {
                if (self.session.getActive() == true){
                    // AJout d'un like TODO
                    Button(action : {
                        //p.flike(utilisateur : self.session)
                    }) {
                        Text("Like")
                    }
                    // AJout d'un dislike TODO
                    Button(action : {
                       // p.fdislike(utilisateur : self.session)
                    }) {
                        Text("Dislike")
                    }
                }
                
            }  .padding(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, 340).padding(.top, 5.0)
            
        }
        List {
            ForEach (self.proposList.proposListe) { p in
                ProposRow(propos: Contenu, liked: contenu.isLiked(self.session), session: <#T##Utilisateur?#>)
            }
        }*/
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
