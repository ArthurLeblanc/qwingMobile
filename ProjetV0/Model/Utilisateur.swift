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
    }
    
    init(pseudo: String, email: String, password: String, proposLikes: [Propos]?, commentairesLikes: [Commentaire]?, reponsesLikes: [Reponse]?) {
        self.pseudo = pseudo
        self.email = email
        self.password = password
        self.proposLikes = proposLikes ?? []
        self.commentairesLikes = commentairesLikes ?? []
        self.reponsesLikes = reponsesLikes ?? []

    }
    
    @Published var pseudo : String
    @Published var email : String
    @Published var password : String
    @Published var proposLikes : [Propos]
    @Published var commentairesLikes : [Commentaire]
    @Published var reponsesLikes : [Reponse]
    
}
