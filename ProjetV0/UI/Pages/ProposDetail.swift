//
//  ContenuDetail.swift
//  ProjetV0
//
//  Created by user164566 on 2/16/20.
//  Copyright © 2020 user164566. All rights reserved.
//

import SwiftUI

struct ProposDetail: View {
    
    
    let session : Utilisateur?
    @State var showComments : Bool = false
    @State var showAnswers : Bool = false
    var formatter = DateFormatter()
    
    var contenu : Propos
    @State var contenuR : String = ""
    @State var categorieR : String = ""
    
    @State var commentaire : String = ""
    
    func postCreator(c : Contenu) -> String {
        if let createurPost = c.createur{
            return createurPost.pseudo
        }
        else {
            return "Anonyme"
        }
    }
    
    init(contenu : Propos, utilisateur : Utilisateur?) {
        self.session = utilisateur
        self.contenu = contenu
    }
    
    func comments() -> some View {
        return
            VStack {
                Text("Espace commentaires :")
                List {
                    ForEach(contenu.commentaires) {
                        c in
                        Text(c.contenu)
                        if (self.session != nil){
                            // Ajout d'un like TODO
                            Button(action : {
                                //c.flike(utilisateur : self.session)
                            }) {
                                Text("Like")
                            }
                            // Ajout d'un dislike TODO
                            Button(action : {
                                //c.fdislike(utilisateur : self.session)
                            }) {
                                Text("Dislike")
                            }
                        }

                    }
                    
                }
                Text("Ajout d'un commentaire :")
                Form {
                    TextField("Commentaire : ", text: $commentaire)
                }
                NavigationLink(destination : Accueil(session: self.session)) {
                    Button(action: {
                        self.contenu.commentaires.append(
                            Commentaire(contenu: self.commentaire, createur: self.session, propos: self.contenu, likes: 0, dislikes: 0))
                        self.showComments = false
                        self.showComments = true


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
                    ForEach(contenu.reponses) {
                            r in
                        ReponseRow(reponse: r)
                            /*Text(r.contenu)
                            if (self.session.getActive() == true){
                                // Ajout d'un like TODO
                                Button(action : {
                                    //r.flike(utilisateur : self.session)
                                }) {
                                    Text("Like")
                                }
                                // Ajout d'un dislike TODO
                                Button(action : {
                                    //r.fdislike(utilisateur : self.session)
                                }) {
                                    Text("Dislike")
                                }
                            }*/
                        }
                    
                }
                Text("Ajout d'une réponse :")
                Form {
                    TextField("Reponse : ", text: $contenuR)
                    TextField("Categorie : ", text : $categorieR)
                }
                NavigationLink(destination : Accueil(session: self.session)) {
                    Button(action: {
                        self.contenu.reponses.append(
                            Reponse(contenu : self.contenuR, categorie : self.categorieR, createur : self.session, propos: self.contenu, likes: 0, dislikes: 0)
                        )
                        self.showAnswers = false
                        self.showAnswers = true

                    }) {
                        Text("Ajouter la reponse")
                    }
                }
        }
        
        
    }
    
    var body: some View {
        formatter.dateFormat = "dd/MM/yyyy"
        
        return VStack {
            ProposRow(propos: contenu)
            HStack {
                Spacer()
                Button(action: {
                    self.showAnswers = false
                    self.showComments = true
                    
                }) {
                    Text("Commentaires")
                }
                Spacer()
                Button(action: {
                    self.showComments = false
                    self.showAnswers = true
                    
                }) {
                    Text("Réponses")
                }
                Spacer()
                
            }.padding(.top, 10.0)
            if(self.showAnswers){
                answers()
            }
            if(self.showComments){
                comments()
            }
            Spacer()
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
