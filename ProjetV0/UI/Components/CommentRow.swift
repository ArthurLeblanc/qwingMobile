//
//  CommentRow.swift
//  ProjetV0
//
//  Created by Anthony Partinico on 12/03/2020.
//  Copyright © 2020 user164566. All rights reserved.
//

import SwiftUI

struct CommentRow: View {
    
    let commentaire : Commentaire
    var session : Utilisateur?
    @State var liked: Bool
    @State var disliked: Bool
    @State var showingAlert = false
    @Binding var liste : [Commentaire]
    
    func nomCreateur() -> some View {
        if let createur = commentaire.createur {
            return
                Text(createur.pseudo)
                    .foregroundColor(.white)
                    .bold()
                    .font(.system(size: 20))
        }
        else{
            return
                Text("Anonyme")
                    .foregroundColor(.white)
                    .bold()
                    .font(.system(size: 20))
        }
    }
    
    var body: some View {
        return
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    nomCreateur()
                    Spacer()
                    if (self.session != nil && self.session?.email == commentaire.createur?.email) {
                        Image(systemName: "trash").padding(.bottom).onTapGesture {
                            WebService().deleteCommentaire(reponse: self.commentaire, createur: self.session!)
                            if let index = self.liste.firstIndex(where: {$0.idC == self.commentaire.idC}) {
                                self.liste.remove(at: index)
                            }
                            self.showingAlert.toggle()
                        }.alert(isPresented: $showingAlert) {
                            Alert(title: Text("Information"), message: Text("Commentaire supprimé"), dismissButton: .default(Text("Ok")))
                        }.padding([.top, .trailing])
                    }
                }
                Text(commentaire.contenu)
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
                HStack {
                    Text(commentaire.date)
                        .foregroundColor(.white)
                        .italic()
                        .opacity(0.5)
                        .font(.system(size: 12))
                    Spacer()
                    Image(systemName: self.disliked ? "hand.thumbsdown.fill" : "hand.thumbsdown").padding(.bottom).onTapGesture {
                        if (self.disliked) {
                            self.session!.undislikeCommentaire(commentaire: self.commentaire)
                            self.commentaire.dislikes -= 1
                        } else {
                            self.session!.dislikeCommentaire(commentaire: self.commentaire)
                            self.commentaire.dislikes += 1
                            if (self.liked) {
                                self.commentaire.likes -= 1
                                self.liked.toggle()
                            }
                        }
                        self.disliked.toggle()
                    }
                    Text(String(self.commentaire.dislikes)).foregroundColor(.white)
                        .font(.caption)
                        .padding([.bottom, .trailing])
                    Image(systemName: self.liked ? "hand.thumbsup.fill" : "hand.thumbsup").padding(.bottom).onTapGesture {
                        if (self.liked) {
                            self.session!.unlikeCommentaire(commentaire: self.commentaire)
                            self.commentaire.likes -= 1
                        } else {
                            self.session!.likeCommentaire(commentaire: self.commentaire)
                            self.commentaire.likes += 1
                            if (self.disliked) {
                                self.commentaire.dislikes -= 1
                                self.disliked.toggle()
                            }
                        }
                        self.liked.toggle()
                    }
                    Text(String(self.commentaire.likes)).foregroundColor(.white)
                        .font(.caption)
                        .padding([.bottom, .trailing])
                }
                
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
            .padding(12)
            .background(Color(red: 0.900, green: 0.445, blue: 0.247))
            .cornerRadius(10)
    }
}

/*struct CommentRow_Previews: PreviewProvider {
 static var previews: some View {
 CommentRow(commentaire: Commentaire())
 }
 }*/
