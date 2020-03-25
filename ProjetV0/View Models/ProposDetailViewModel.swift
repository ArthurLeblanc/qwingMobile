//
//  ProposDetailViewModel.swift
//  ProjetV0
//
//  Created by Anthony Partinico on 12/03/2020.
//  Copyright © 2020 user164566. All rights reserved.
//

import Foundation

class ProposDetailViewModel : ObservableObject {
    
    func addCommentToPropos(commentaire : String, propos : Propos, createur: Utilisateur?) -> Commentaire {
        return WebService().addCommentToPropos(propos: propos, commentaire: commentaire, createur: createur)
    }

    func addReponseToPropos(contenu : String, categorie : String, propos : Propos, createur : Utilisateur?) -> Reponse {
        return WebService().addReponseToPropos(propos: propos, contenu: contenu, categorie: categorie, createur: createur)
    }

}
