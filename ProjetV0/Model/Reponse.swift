//
//  Reponse.swift
//  ProjetV0
//
//  Created by user164566 on 2/16/20.
//  Copyright © 2020 user164566. All rights reserved.
//

import Foundation

class Reponse : Contenu {
    
    public init(contenu: String, categorie : String, createur : Utilisateur?, propos: Propos, likes: Int?, dislikes: Int?, idC : String) {
        self.propos = propos
        self.categorie = categorie
        if let a = dislikes  {
            self.dislikes = a
        }
        super.init(contenu : contenu, createur: createur, likes: likes, idC : idC)
    }
    
    @Published var categorie : String = ""
    @Published var dislikes : Int = 0
    @Published var propos : Propos
    
    static func isLiked(rep: Reponse, user: Utilisateur?) -> Bool {
        if (user != nil) {
            return (user!.reponsesLikes.firstIndex{$0.idC == rep.idC} != nil)
        }
        return false
    }
    
    static func isDisliked(rep: Reponse, user: Utilisateur?) -> Bool {
        if (user != nil) {
            return (user!.reponsesDislikes.firstIndex{$0.idC == rep.idC} != nil)
        }
        return false
    }
    
}
