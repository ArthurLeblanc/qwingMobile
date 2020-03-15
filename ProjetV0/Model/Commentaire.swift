//
//  Commentaire.swift
//  ProjetV0
//
//  Created by user164566 on 2/16/20.
//  Copyright © 2020 user164566. All rights reserved.
//

import Foundation

class Commentaire : Contenu {
    
    public init(contenu: String, createur : Utilisateur?, propos: Propos, likes: Int?, dislikes: Int?, idC : String) {
        self.propos = propos
        if let a = dislikes  {
            self.dislikes = a
        }
        super.init(contenu : contenu, createur: createur, likes: likes, idC : idC)
    }
    
    @Published var dislikes : Int = 0
    @Published var propos : Propos
    
}
