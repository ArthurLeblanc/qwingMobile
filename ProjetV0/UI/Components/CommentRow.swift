//
//  CommentRow.swift
//  ProjetV0
//
//  Created by Anthony Partinico on 12/03/2020.
//  Copyright © 2020 user164566. All rights reserved.
//

import SwiftUI

extension Date {

func getElapsedInterval() -> String {

    let interval = Calendar.current.dateComponents([.year, .month, .day], from: self, to: Date())

    if let year = interval.year, year > 0 {
        return year == 1 ? "il y a \(year) an" :
            "il y a \(year) ans"
    } else if let month = interval.month, month > 0 {
        return "il y a \(month) mois"
    } else if let day = interval.day, day > 0 {
        return day == 1 ? "il y a \(day) jour" :
            "il y a \(day) jours"
    } else {
        return "Aujourd'hui"

    }

}
}

struct CommentRow: View {
    
    let commentaire : Commentaire
    var session : Utilisateur?
    @State var showingAlert = false
    
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
                            Image(systemName: "hand.thumbsup").padding(.bottom).onTapGesture {
                                WebService().deleteCommentaire(reponse: self.commentaire, createur: self.session!)
                                self.showingAlert.toggle()
                            }.alert(isPresented: $showingAlert) {
                                Alert(title: Text("Information"), message: Text("Commentaire supprimé"), dismissButton: .default(Text("Ok")))
                            }.padding([.top, .trailing])
                        }
                    }
                nomCreateur()
                Text(commentaire.contenu)
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
                HStack {
                    Text(commentaire.date.getElapsedInterval())
                        .foregroundColor(.white)
                        .italic()
                        .opacity(0.5)
                        .font(.system(size: 12))
                    Spacer()
                    Image(systemName: "hand.thumbsdown").padding(.bottom)                        .foregroundColor(.white)

                    Text(String(self.commentaire.dislikes))                        .foregroundColor(.white)

                        .font(.caption)
                        .padding([.bottom, .trailing])
                    Image(systemName: "hand.thumbsup").padding(.bottom)                        .foregroundColor(.white)

                    Text(String(self.commentaire.likes))                        .foregroundColor(.white)

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
