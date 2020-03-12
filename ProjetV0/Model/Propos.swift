//
//  Propos.swift
//  ProjetV0
//
//  Created by user164566 on 2/16/20.
//  Copyright © 2020 user164566. All rights reserved.
//

import Foundation

class Propos : Contenu {
 
    public init(contenu: String, categorie : String, createur : Utilisateur?, likes: Int?, reponses: [Reponse]?, commentaires: [Commentaire]?) {
        super.init(contenu : contenu, createur : createur, likes: likes)
        self.categorie = categorie
        self.reponses = reponses ?? []
        self.commentaires = commentaires ?? []
    }
    
    @Published var categorie : String = ""
    @Published var date : Date = Date()
    var reponses : [Reponse] = [Reponse]()
    var commentaires : [Commentaire] = [Commentaire]()
}

