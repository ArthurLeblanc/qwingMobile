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
        self.commentairesDislikes = []
        self.reponsesLikes = []
        self.reponsesDislikes = []
        self.token = ""
    }
    
    init(pseudo: String, email: String, password: String, proposLikes: [Propos]?, commentairesLikes: [Commentaire]?, reponsesLikes: [Reponse]?, token: String?) {
        self.pseudo = pseudo
        self.email = email
        self.password = password
        self.proposLikes = proposLikes ?? []
        self.commentairesLikes = commentairesLikes ?? []
        self.commentairesDislikes = []
        self.reponsesLikes = reponsesLikes ?? []
        self.reponsesDislikes = []
        self.token = token ?? ""

    }
    
    @Published var pseudo : String
    @Published var email : String
    @Published var password : String
    @Published var token : String
    @Published var proposLikes : [Propos]
    @Published var commentairesLikes : [Commentaire]
    @Published var commentairesDislikes : [Commentaire]
    @Published var reponsesLikes : [Reponse]
    @Published var reponsesDislikes : [Reponse]
    
    
    // Ajoute un propos à la liste des propos aimés
    func likePropos(propos: Propos) {
        self.proposLikes.append(propos)
        // Déléguation à l'API qui s'occupe de l'insertion dans la base de données
        WebService().likePropos(propos: propos, utilisateur: self)
    }
    
    // Supprime un propos de la liste des propos aimés
    func dislikePropos(propos: Propos) {
        // Récupère l'index du propos et le supprime
        if let index = self.proposLikes.firstIndex(where: {$0.idC == propos.idC}) {
            self.proposLikes.remove(at: index)
            //Déléguation à l'API qui s'occupe de la suppression dans la base de données
            WebService().dislikePropos(propos: propos, utilisateur: self)
        }

    }
    
    // Ajoute une réponse à la liste des propos aimés
    func likeReponse(reponse: Reponse) {
        self.reponsesLikes.append(reponse)
        if let index = self.reponsesDislikes.firstIndex(where: {$0.idC == reponse.idC}) {
            self.reponsesDislikes.remove(at: index)
        }
        WebService().actionReponse(reponse: reponse, utilisateur: self, action: "like-reponse")
    }
    
    // Supprime une réponse de la liste des réponses aimées
    func unlikeReponse(reponse: Reponse) {
        if let index = self.reponsesLikes.firstIndex(where: {$0.idC == reponse.idC}) {
            self.reponsesLikes.remove(at: index)
            WebService().actionReponse(reponse: reponse, utilisateur: self, action: "unlike-reponse")
        }
    }
    
    // Supprime une réponse de la liste des réponses non aimées
    func undislikeReponse(reponse: Reponse) {
        if let index = self.reponsesDislikes.firstIndex(where: {$0.idC == reponse.idC}) {
            self.reponsesDislikes.remove(at: index)
            WebService().actionReponse(reponse: reponse, utilisateur: self, action: "undislike-reponse")
        }
    }
    
    // Supprime une réponse de la liste des réponses aimées et l'ajoute à la liste des réponses non aimées
    func dislikeReponse(reponse: Reponse) {
        self.reponsesDislikes.append(reponse)
        if let index = self.reponsesLikes.firstIndex(where: {$0.idC == reponse.idC}) {
            self.reponsesLikes.remove(at: index)
        }
        WebService().actionReponse(reponse: reponse, utilisateur: self, action: "dislike-reponse")
    }
    
    // Ajoute un commentaire à la liste des commentaires aimés
    func likeCommentaire(commentaire: Commentaire) {
        self.commentairesLikes.append(commentaire)
        if let index = self.commentairesDislikes.firstIndex(where: {$0.idC == commentaire.idC}) {
            self.commentairesDislikes.remove(at: index)
        }
        WebService().actionCommentaire(commentaire: commentaire, utilisateur: self, action: "like-commentaire")
    }
    
    // Supprime un commentaire de la liste des commentaires aimés
    func unlikeCommentaire(commentaire: Commentaire) {
        if let index = self.commentairesLikes.firstIndex(where: {$0.idC == commentaire.idC}) {
            self.commentairesLikes.remove(at: index)
            WebService().actionCommentaire(commentaire: commentaire, utilisateur: self, action: "unlike-commentaire")
        }
    }
    
    
    // Supprime un commentaire de la liste des commentaires non aimés
    func undislikeCommentaire(commentaire: Commentaire) {
        if let index = self.commentairesDislikes.firstIndex(where: {$0.idC == commentaire.idC}) {
            self.commentairesDislikes.remove(at: index)
            WebService().actionCommentaire(commentaire: commentaire, utilisateur: self, action: "undislike-commentaire")
        }
    }
    
    // Supprime un commentaire de la liste des commentaires aimés et l'ajoute dans la liste des commentaires non aimés
    func dislikeCommentaire(commentaire: Commentaire) {
        if let index = self.commentairesLikes.firstIndex(where: {$0.idC == commentaire.idC}) {
            self.commentairesLikes.remove(at: index)
        }
        WebService().actionCommentaire(commentaire: commentaire, utilisateur: self, action: "dislike-commentaire")
    }

    
}
