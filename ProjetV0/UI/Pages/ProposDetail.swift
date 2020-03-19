//
//  ContenuDetail.swift
//  ProjetV0
//
//  Created by user164566 on 2/16/20.
//  Copyright © 2020 user164566. All rights reserved.
//

import SwiftUI

struct ProposDetail: View {
    
    var proposDetailViewModel : ProposDetailViewModel = ProposDetailViewModel()
    @State var session : Utilisateur?
    @State var showComments : Bool = false
    @State var showAnswers : Bool = false
    var formatter = DateFormatter()
    
    @State var contenu : Propos
    @State var contenuR : String = ""
    @State var categorieR : String = ""
    
    @State var commentaire : String = ""
    
    @State var picker : PickerView = PickerView(categories : ["Humour", "Texte de loi", "Citation", "Autre"])
    
    func postCreator(c : Contenu) -> String {
        if let createurPost = c.createur{
            return createurPost.pseudo
        }
        else {
            return "Anonyme"
        }
    }
    
    func comments() -> some View {
        return
            VStack {
                Text("Espace commentaires :")
                List {
                    ForEach(self.contenu.commentaires) {
                        c in
                        CommentRow(commentaire : c, session: self.session, liked: Commentaire.isLiked(com: c, user: self.session), disliked: Commentaire.isDisliked(com: c, user: self.session))
                    }
                    
                }
                Spacer()
                Text("Ajouter un commentaire")
                Form {
                    TextField("Commentaire : ", text: $commentaire)
                }
                NavigationLink(destination : Accueil(session: self.session)) {
                    Button(action: {
                        self.proposDetailViewModel.addCommentToPropos(commentaire: self.commentaire, propos: self.contenu, createur: self.session)
                        self.contenu.commentaires.append(
                            Commentaire(contenu: self.commentaire, createur: self.session, propos: self.contenu, likes: 0, dislikes: 0, idC: "", date: Date.dateToString(date: Date())))
                        
                    }) {
                        Text("Ajouter le commentaire")
                    }
                }
                
        }
        
    }
    
    func answers() -> some View {
        return
            VStack {
                Text("Espace réponses :")
                    .padding(.top)
                List {
                    ForEach(self.contenu.reponses) {
                        r in
                        ReponseRow(reponse: r, session: self.session, liked: Reponse.isLiked(rep: r, user: self.session), disliked: Reponse.isDisliked(rep: r, user: self.session))
                    }
                }
                Spacer()
                Text("Ajout d'une réponse :")
                Form {
                    TextField("Reponse : ", text: $contenuR)
                    self.picker
                }
                NavigationLink(destination : Accueil(session: self.session)) {
                    Button(action: {
                        self.proposDetailViewModel.addReponseToPropos(contenu: self.contenuR, categorie: self.picker.categories[self.picker.selection], propos: self.contenu, createur: self.session)
                        self.contenu.reponses.append(
                            Reponse(contenu : self.contenuR, categorie : self.categorieR, createur : self.session, propos: self.contenu, likes: 0, dislikes: 0, idC: "", date: Date.dateToString(date: Date()))
                         )
                    }) {
                        Text("Ajouter la reponse")
                    }
                }
        }
        
        
    }
    
    var body: some View {
        formatter.dateFormat = "dd/MM/yyyy"
        
        return VStack {
            ProposRow(propos: contenu, liked: contenu.isLiked(user: self.session), session: self.session)
            HStack {
                Spacer()
                Button(action: {
                    self.showAnswers = false
                    self.showComments = true
                    
                }) {
                    Text("Commentaires")                                    .foregroundColor(Color(red: 0.933, green: 0.412, blue: 0.247))
                }
                Spacer()
                Button(action: {
                    self.showComments = false
                    self.showAnswers = true
                    
                }) {
                    Text("Réponses")                                    .foregroundColor(Color(red: 0.933, green: 0.412, blue: 0.247))
                }
                Spacer()
                
            }.padding(.top, 10.0).padding(.bottom, 10.0)
            if(self.showAnswers){
                answers()
            }
            if(self.showComments){
                comments()
            }
        }
    }
}

/*
 struct ContenuDetail_Previews: PreviewProvider {
 static var previews: some View {
 ProposDetail()
 }
 }
 
 */
