//
//  ProposDetailViewModel.swift
//  ProjetV0
//
//  Created by Anthony Partinico on 12/03/2020.
//  Copyright © 2020 user164566. All rights reserved.
//

import Foundation

class ProposDetailViewModel : ObservableObject {
    
    func addCommentToPropos(commentaire : String, propos : Propos) {
        WebService().addCommentToPropos(propos: propos, commentaire: commentaire)
    }

    func addReponseToPropos(contenu : String, categorie : String, propos : Propos, createur : Utilisateur?) {
        WebService().addReponseToPropos(propos: propos, contenu: contenu, categorie: categorie, createur: createur)
    }

}
