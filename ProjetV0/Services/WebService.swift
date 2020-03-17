//
//  WebService.swift
//  ProjetV0
//
//  Created by user164566 on 3/7/20.
//  Copyright © 2020 user164566. All rights reserved.
//

import Foundation
import SwiftyJSON

// Classe qui fait la liaison avec l'API
class WebService : ObservableObject {
    let url : String = "https://qwing.herokuapp.com/api/"
    // Définit une session sans configuration
    let session = URLSession.shared
    // Définit la tâche : DataTask (GET), UploadTask(POST, PUT), DownloadTask(GET File)
    var dataTask: URLSessionDataTask?
    
    // Retourne tous les propos
    func getPropos(completion: @escaping ([Propos]?) -> ()) {
        var proposList : [Propos] = []
        // Complétion de l'URL
        guard let url = URL(string: self.url + "propos") else {
            fatalError("URL invalide")
        }
        session.dataTask(with: url) { (data, response, error) in
            // Vérifie les erreurs / si il y a des données
            if error != nil || data == nil {
                print("Erreur côté client")
                return
            }
            // Vérifie le code HTTP de réponse du serveur
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Erreur du serveur")
                return
            }
            // Vérifie que le format des données du serveur en réponse est bien du JSON
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
            // Convertie les données en JSON
            do {
                let json = try JSON(data: data!)
                // Pour chaque propos dans le json, créee un propos et l'ajoute à la liste des propos
                for propos in json.arrayValue {
                    if let unPropos = self.decodePropos(propos: propos) {
                        proposList.append(unPropos)
                    }
                }
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                completion(proposList)
            }
            
        }.resume()
        
    }
    
    func getTokenFromLoginInfos(email : String, password : String) -> String {
        
        let url = URL(string : self.url + "users/login")
        
        guard let requestUrl = url else { fatalError() }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        let postString = "email=\(email)&password=\(password)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        var tokenResult : String = ""
        let semaphore = DispatchSemaphore(value : 0)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil || data == nil {
                print("Erreur côté client 1")
                return
            }
            // Vérifie le code HTTP de réponse du serveur
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Erreur du serveur 1")
                return
            }
            // Vérifie que le format des données du serveur en réponse est bien du JSON
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type 1!")
                return
            }
            do {
                let json = try JSON(data: data!)
                print("json : \(json)")
                
                guard let tokenUser = json.dictionaryValue["token"]?.string else {
                    print("Wrong user informations")
                    return
                }
                tokenResult = tokenUser
                print("aaa " + tokenResult)
                semaphore.signal()
                
                
            }
            catch {
                print("JSON error: \(error.localizedDescription)")
            }
            
            
        }
        task.resume()
        semaphore.wait()
        print("resultat : " + tokenResult)
        return tokenResult
    }
    
    func getUserInfosFromToken(token : String) -> Utilisateur? {
        let url = URL(string : self.url + "users")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "auth-token")
        var loggedUser : Utilisateur? = nil
        let semaphore = DispatchSemaphore(value : 0)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil || data == nil {
                print("Erreur côté client 2")
                return
            }
            // Vérifie le code HTTP de réponse du serveur
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Erreur du serveur 2")
                return
            }
            // Vérifie que le format des données du serveur en réponse est bien du JSON
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type 2!")
                return
            }
            do {
                let json = try JSON(data: data!)
                guard let pseudo = json.dictionaryValue["pseudo"]?.string, let email = json.dictionaryValue["email"]?.string else {
                    print("Wrong user informations")
                    return
                }
                
                print(json["likesPropos"])
                
                loggedUser = Utilisateur(pseudo: pseudo, email: email, password: "", proposLikes: [Propos](), commentairesLikes: [Commentaire](), reponsesLikes: [Reponse](), token: token)
                
                for propos in json["likesPropos"].arrayValue {
                    print(propos)
                    if let unPropos = self.decodePropos(propos: propos) {
                        loggedUser!.proposLikes.append(unPropos)
                    }
                }
                
                /*
                 for rep in json["likesReponses"].arrayValue {
                 if let unPropos = self.decodePropos(propos: propos) {
                 loggedUser!.proposLikes.append(unPropos)
                 }
                 }
                 
                 // Création des commentaires associés au propos
                 for com in json["likesCommentaires"].arrayValue {
                 
                 } */
                
                semaphore.signal()
                print(loggedUser!.pseudo)
            }
            catch {
                print("JSON error: \(error.localizedDescription)")
            }
            
            
        }.resume()
        semaphore.wait()
        return loggedUser
    }
    //TODO Crypter password
    func login(email : String, password : String) -> Utilisateur? {
        let token = getTokenFromLoginInfos(email: email, password: password)
        return getUserInfosFromToken(token: token)
    }
    
    func signup(email : String, pseudo : String, password : String) -> Utilisateur?{
        let url = URL(string : self.url + "users/register")
        guard let requestUrl = url else { fatalError() }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        let postString = "email=\(email)&pseudo=\(pseudo)&password=\(password)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let semaphore = DispatchSemaphore(value : 0)
        //var createdUser : Utilisateur? = nil
        var token : String = ""
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil || data == nil {
                print("Erreur côté client 1")
                return
            }
            // Vérifie le code HTTP de réponse du serveur
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Erreur du serveur : Adresse mail déjà utilisée")
                return
            }
            // Vérifie que le format des données du serveur en réponse est bien du JSON
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type 1!")
                return
            }
            do {
                let json = try JSON(data: data!)
                print("json : \(json)")
                
                guard let tokenUser = json.dictionaryValue["token"]?.string else {
                    print("Wrong user informations")
                    return
                }
                token = tokenUser
                semaphore.signal()
                
                
                
            }
            catch {
                print("JSON error: \(error.localizedDescription)")
            }
            
            
        }
        task.resume()
        semaphore.wait()
        //print("utilisateur : \(getUserInfosFromToken(token: token))")
        return getUserInfosFromToken(token: token)
    }
    
    func likePropos(propos: Propos, utilisateur: Utilisateur) {
        let url = URL(string : self.url + "propos/like-propos")
        guard let requestUrl = url else { fatalError() }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "PUT"
        let putString = "proposId=\(propos.idC)"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(utilisateur.token, forHTTPHeaderField: "auth-token")
        request.httpBody = putString.data(using: String.Encoding.utf8)
        session.dataTask(with: request) { (data, response, error) in
            
            if error != nil || data == nil {
                print("Erreur côté client")
                return
            }
            print("Code de réponse http : \((response as! HTTPURLResponse).statusCode)")
            // Vérifie le code HTTP de réponse du serveur
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Erreur du serveur")
                return
            }
            // Vérifie que le format des données du serveur en réponse est bien du JSON
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
            do {
                let json = try JSON(data: data!)
                print("json : \(json)")
                
            }
            catch {
                print("JSON error: \(error.localizedDescription)")
            }
            
            
        }.resume()
    }
    
    func dislikePropos(propos: Propos, utilisateur: Utilisateur) {
        let url = URL(string : self.url + "propos/dislike-propos")
        guard let requestUrl = url else { fatalError() }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "DELETE"
        let putString = "proposId=\(propos.idC)"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(utilisateur.token, forHTTPHeaderField: "auth-token")
        request.httpBody = putString.data(using: String.Encoding.utf8)
        session.dataTask(with: request) { (data, response, error) in
            
            if error != nil || data == nil {
                print("Erreur côté client")
                return
            }
            print("Code de réponse http : \((response as! HTTPURLResponse).statusCode)")
            // Vérifie le code HTTP de réponse du serveur
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Erreur du serveur")
                return
            }
            // Vérifie que le format des données du serveur en réponse est bien du JSON
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
            do {
                let json = try JSON(data: data!)
                print("json : \(json)")
                
            }
            catch {
                print("JSON error: \(error.localizedDescription)")
            }
            
            
        }.resume()
    }
    
    
    func addCommentToPropos(propos : Propos, commentaire : String) {
        print("id du propos : " + propos.idC)
        let url = URL(string : self.url + "propos/add-commentaire")
        guard let requestUrl = url else { fatalError() }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "PUT"
        print("contenu du commentaire : " + commentaire)
        let putString = "contenu=\(commentaire)&proposId=\(propos.idC)"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = putString.data(using: String.Encoding.utf8)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil || data == nil {
                print("Erreur côté client")
                return
            }
            print("Code de réponse http : \((response as! HTTPURLResponse).statusCode)")
            // Vérifie le code HTTP de réponse du serveur
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Erreur du serveur")
                return
            }
            // Vérifie que le format des données du serveur en réponse est bien du JSON
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
            do {
                let json = try JSON(data: data!)
                print("json : \(json)")
                
            }
            catch {
                print("JSON error: \(error.localizedDescription)")
            }
            
            
        }
        task.resume()
    }
    
    func addPropos(contenu : String, categorie : String, createur : Utilisateur?) {
        let url = URL(string : self.url + "propos/create-propos")
        guard let requestUrl = url else { fatalError() }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        let postString = "contenu=\(contenu)&categorie=\(categorie)"
        if let user = createur {
            request.setValue(user.token, forHTTPHeaderField: "auth-token")
        }
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil || data == nil {
                print("Erreur côté client")
                return
            }
            print("Code de réponse http : \((response as! HTTPURLResponse).statusCode)")
            // Vérifie le code HTTP de réponse du serveur
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Erreur du serveur")
                return
            }
            // Vérifie que le format des données du serveur en réponse est bien du JSON
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
            do {
                let json = try JSON(data: data!)
                print(json)
            }
            catch {
                print("JSON error: \(error.localizedDescription)")
            }
            
            
        }
        task.resume()
    }
    
    func addReponseToPropos(propos : Propos, contenu : String, categorie : String, createur : Utilisateur?) {
        print("id du propos : " + propos.idC)
        let url = URL(string : self.url + "propos/add-reponse")
        guard let requestUrl = url else { fatalError() }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "PUT"
        let putString = "contenu=\(contenu)&proposId=\(propos.idC)&categorie=\(categorie)"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        if let user = createur {
            request.setValue(user.token, forHTTPHeaderField: "auth-token")
            request.httpBody = putString.data(using: String.Encoding.utf8)
            let task = session.dataTask(with: request) { (data, response, error) in
                
                if error != nil || data == nil {
                    print("Erreur côté client")
                    return
                }
                print("Code de réponse http : \((response as! HTTPURLResponse).statusCode)")
                // Vérifie le code HTTP de réponse du serveur
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    print("Erreur du serveur")
                    return
                }
                // Vérifie que le format des données du serveur en réponse est bien du JSON
                guard let mime = response.mimeType, mime == "application/json" else {
                    print("Wrong MIME type!")
                    return
                }
                do {
                    let json = try JSON(data: data!)
                    print("json : \(json)")
                    
                }
                catch {
                    print("JSON error: \(error.localizedDescription)")
                }
                
                
            }
            task.resume()
        }
        
    }
    //.buttonStyle(PlainButtonStyle)

}
    
    extension WebService {
        
        func decodePropos(propos: JSON) -> Propos? {
            let reponses = [Reponse]()
            let commentaires = [Commentaire]()
            // Récupération des données d'un propos
            guard let contenu = propos["contenu"].string, let categorie = propos["categorie"]["contenu"].string, let likes = propos["likes"].int, let id = propos["_id"].string else {
                print("Erreur dans la structure du JSON")
                return nil
            }
            // nil si le propos a été créé anonyment, ajout de l'utilisateur sinon
            var createur : Utilisateur? = nil
            if (propos["creator"]).exists() {
                createur = Utilisateur(pseudo: propos["creator"]["pseudo"].string!, email: propos["creator"]["email"].string!, password: "")
            }
            // Création du propos
            let unPropos : Propos = Propos(contenu: contenu, categorie: categorie, createur: createur, likes: likes, reponses: reponses, commentaires: commentaires, idC : id)
            
            for rep in propos["reponses"].arrayValue {
                if let reponse = decodeReponse(propos: unPropos, createur: createur, rep: rep) {
                    unPropos.reponses.append(reponse)
                }
            }
            
            for com in propos["commentaires"].arrayValue {
                if let commentaire = (decodeCommentaire(propos: unPropos, createur: createur, com: com)) {
                    unPropos.commentaires.append(commentaire)
                }
            }
            return unPropos
        }
        
        func decodeReponse(propos: Propos, createur: Utilisateur?, rep: JSON) -> Reponse? {
            guard let contenu = rep["contenu"].string, let categorie = rep["categorie"]["contenu"].string, let likes = rep["likes"].int, let dislikes = rep["dislikes"].int, let idr = rep["_id"].string else {
                print("Erreur dans la structure du JSON")
                return nil
            }
            // Création de la réponse et ajout à la liste des réponses du propos précédemment créé
            // TODO récupérér catégorie rep["categorie"]["contenu"] -> trouver comment populate dans le serveur
            return Reponse(contenu: contenu, categorie: categorie, createur: createur, propos: propos, likes: likes, dislikes: dislikes, idC : idr)
        }
        
        func decodeCommentaire(propos: Propos, createur: Utilisateur?, com: JSON) -> Commentaire? {
            // Récupération des données d'un commentaire
            guard let contenu = com["contenu"].string, let likes = com["likes"].int, let dislikes = com["dislikes"].int, let idc = com["_id"].string else {
                print("Erreur dans la structure du JSON")
                return nil
            }
            // Création du commentaire et ajout à la liste des commentaires du propos précédemment créé
            return Commentaire(contenu: contenu, createur: createur, propos: propos, likes: likes, dislikes: dislikes, idC : idc)
        }
}
