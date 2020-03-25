//
//  ProposListeViewModel.swift
//  ProjetV0
//
//  Created by user164566 on 3/8/20.
//  Copyright © 2020 user164566. All rights reserved.
//

import Foundation

class ProposListeViewModel : ObservableObject {
    @Published var proposListe = [Propos]()
    static let singleton = ProposListeViewModel()
    
    init() {
        WebService().getPropos { propos in
            if let propos = propos {
                self.proposListe = propos
            }
            
        }
    }
    func addPropos(contenu : String, categorie : String, createur : Utilisateur?) -> Propos {
        let propos = WebService().addPropos(contenu : contenu , categorie: categorie, createur: createur)
        return propos
    }
    
    func getProposFromUser(user : Utilisateur) -> [Propos]{
        return WebService().getProposFromUser(user: user)
    }
}


