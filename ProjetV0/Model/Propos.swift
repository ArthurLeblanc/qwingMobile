//
//  Propos.swift
//  ProjetV0
//
//  Created by user164566 on 2/16/20.
//  Copyright © 2020 user164566. All rights reserved.
//

import Foundation

class Propos : Contenu {
 
    public init(contenu: String, categorie : String, createur : Utilisateur?, likes: Int?, reponses: [Reponse]?, commentaires: [Commentaire]?, idC : String, date: String) {
        super.init(contenu : contenu, createur : createur, likes: likes, idC : idC, date: date)
        self.categorie = categorie
        self.reponses = reponses ?? []
        self.commentaires = commentaires ?? []
        self.dateP = conversionStringToDate(strDate: date)
    }
    
    @Published var categorie : String = ""
    @Published var dateP : Date = Date()
    var reponses : [Reponse] = [Reponse]()
    var commentaires : [Commentaire] = [Commentaire]()
    
    func isLiked(user: Utilisateur?) -> Bool {
        if (user != nil) {
            return (user!.proposLikes.firstIndex{$0.idC == self.idC} != nil)
        }
        return false
    }
    
    func conversionStringToDate(strDate : String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd'/'MM'/'yyyy"
        let date = dateFormatter.date(from: strDate)
        return date!
    }
    
}

