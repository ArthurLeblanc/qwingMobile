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
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("proposé par - \(propos.createur?.pseudo ?? "Anonyme")")
                .font(.caption)
                .padding([.top, .leading])                
            }
            Text(self.propos.contenu)
                .font(.headline)
                .padding(.all)
                .frame(height: 75.0)
            HStack {
                //Text("Voir les réponses >").font(.caption).padding([.leading, .bottom])
                Spacer()
                Image(systemName: "hand.thumbsup").padding(.bottom)
                Text(String(self.propos.likes))
                    .font(.caption)
                    .padding([.bottom, .trailing])
            }
        }.border(Color.black, width: 1).padding()
    }
}

/*
struct ProposRow_Previews: PreviewProvider {
    static var previews: some View {
        ProposRow(propos: $proposListe)
    }
}
*/
