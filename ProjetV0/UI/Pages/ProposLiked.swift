//
//  ProposLiked.swift
//  ProjetV0
//
//  Created by Anthony Partinico on 19/03/2020.
//  Copyright © 2020 user164566. All rights reserved.
//

import SwiftUI

struct ProposLiked: View {
    
    var session : Utilisateur?
    
    var proposList : [Propos]  = []
    
    init(session : Utilisateur?){
        self.session = session
        if let user = self.session {
            self.proposList = user.proposLikes
        }
    }
    
    

    var body: some View {
        VStack{
            Text("Mes propos entendus")
                .font(.headline).foregroundColor(Color(red: 0.02, green: 0.153, blue: 0.208))
            Divider()
            List {
                ForEach (self.proposList) {
                    p in
                    NavigationLink(destination : ProposDetail(session: self.session, contenu : p)) {
                        ProposRow(propos: p, liked: p.isLiked(user: self.session), session: self.session)
                    }
                }
            }
        }
    }
    
}

/*struct ProposLiked_Previews: PreviewProvider {
    static var previews: some View {
        ProposLiked()
    }
}*/
