//
//  Contenu.swift
//  ProjetV0
//
//  Created by user164566 on 2/16/20.
//  Copyright © 2020 user164566. All rights reserved.
//

import Foundation

class Contenu : Identifiable, ObservableObject {
    
    public init (contenu: String, createur : Utilisateur?, likes: Int?) {
        self.contenu = contenu
        if let a = likes  {
            self.likes = a
        }
        if let user = createur {
            self.createur = user
        }
    }
    
    @Published var contenu : String
    @Published var likes : Int = 0
    @Published var createur : Utilisateur? = nil
    
    var id = UUID()

}

