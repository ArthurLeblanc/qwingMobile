//
//  Utilisateur.swift
//  ProjetV0
//
//  Created by user164566 on 2/28/20.
//  Copyright © 2020 user164566. All rights reserved.
//

import Foundation
import SwiftUI

class Utilisateur : Identifiable {
    
    init(pseudo: String, email: String, password: String) {
        self.pseudo = pseudo
        self.email = email
        self.password = password
        self.proposLikes = []
        self.commentairesLikes = []
        self.reponsesLikes = []
        self.token = ""
    }
    
    init(pseudo: String, email: String, password: String, proposLikes: [Propos]?, commentairesLikes: [Commentaire]?, reponsesLikes: [Reponse]?, token: String?) {
        self.pseudo = pseudo
        self.email = email
        self.password = password
        self.proposLikes = proposLikes ?? []
        self.commentairesLikes = commentairesLikes ?? []
        self.reponsesLikes = reponsesLikes ?? []
        self.token = token ?? ""

    }
    
    @Published var pseudo : String
    @Published var email : String
    @Published var password : String
    @Published var token : String
    @Published var proposLikes : [Propos]
    @Published var commentairesLikes : [Commentaire]
    @Published var reponsesLikes : [Reponse]
    
    // Ajoute un propos à la liste des propos aimés
    func likePropos(propos: Propos) {
        self.proposLikes.append(propos)
        // Déléguation à l'API qui s'occupe de l'insertion dans la base de données
        WebService().likePropos(propos: propos, utilisateur: self)
    }
    
    // Supprime un propos de la liste des propos aimés
    func dislikePropos(propos: Propos) {
        // Récupère l'index du propos et le supprime
        if let index = self.proposLikes.firstIndex(where: {$0 === propos}) {
            self.proposLikes.remove(at: index)
            //Déléguation à l'API qui s'occupe de la suppression dans la base de données
            WebService().likePropos(propos: propos, utilisateur: self)
        }

    }

    
}
