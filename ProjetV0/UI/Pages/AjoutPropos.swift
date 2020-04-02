//
//  AjoutContenu.swift
//  ProjetV0
//
//  Created by user164566 on 2/16/20.
//  Copyright © 2020 user164566. All rights reserved.
//

import SwiftUI

struct AjoutPropos: View {
    
    @Binding var session : Utilisateur?
    @State var contenu : String = ""
    @State var categorie : String = ""
    @State var jaime : Int = 0
    @State var jaimePas : Int = 0
    @Environment(\.presentationMode) var presentationMode
    @State var picker : PickerView = PickerView(categories : ["Dans la rue", "Dans les transports", "Au travail", "Autre"])
    @EnvironmentObject var proposListe : ProposListeViewModel
    @State var showModal : Bool = false
    @State var search : String = ""
    
    /*
     init(utilisateur : Utilisateur, liste : UtilisateurListe, propos : Binding<[Propos]>){
     self.session = utilisateur
     self.listeBD = liste
     //self.$globalPropos = propos
     }
     */
    
    var body: some View {
        VStack {
            Text("Ajout d'un contenu")
            if (self.showModal) {
                
                Text("Un propos similaire a été trouvé !")
                Text(self.search)
                HStack {
                    Button(action: {
                        self.showModal.toggle()
                    }) {
                        Text("Annuler")
                    }
                    Spacer()
                    Button(action: {
                        let propos = ProposListeViewModel().addPropos(contenu: self.contenu, categorie: self.picker.categories[self.picker.selection], createur: self.session)
                        self.proposListe.proposListe.append(propos)
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Mon propos est différent !")
                    }
                }
            }
            Form {
                TextField("Contenu : ", text: $contenu)
                self.picker

            }
            


            //Attention Bien faire le retour ou effacer les champs
            NavigationLink(destination : Accueil()) {
                Button(action: {
                    let p = WebService().searchPropos(search: self.contenu)
                    if (p[0] != "0") {
                        let score = Double(p[0]) ?? 0
                        if (score > 2) {
                            self.search = p[1]
                            self.showModal.toggle()
                        }
                    } else {
                        let propos = ProposListeViewModel().addPropos(contenu: self.contenu, categorie: self.picker.categories[self.picker.selection], createur: self.session)
                        self.proposListe.proposListe.append(propos)
                        self.presentationMode.wrappedValue.dismiss()
                    }

                }) {
                    Text("Ajouter")
                }
            }
            
        }
    }
}


/*
 struct AjoutContenu_Previews: PreviewProvider {
 static var previews: some View {
 AjoutContenu()
 }
 }
 */
