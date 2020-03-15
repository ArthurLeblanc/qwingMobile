//
//  Contenu.swift
//  ProjetV0
//
//  Created by user164566 on 2/16/20.
//  Copyright © 2020 user164566. All rights reserved.
//

import Foundation

class Contenu : Identifiable, ObservableObject {
    
    public init (contenu: String, createur : Utilisateur?, likes: Int?, idC : String) {
        self.contenu = contenu
        self.idC = idC
        if let a = likes  {
            self.likes = a
        }
        if let user = createur {
            self.createur = user
        }
    }
    
    @Published var contenu : String
    @Published var idC : String

    @Published var likes : Int = 0
    @Published var date : Date = Date()
    @Published var createur : Utilisateur? = nil
}

