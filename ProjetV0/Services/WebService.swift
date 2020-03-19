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
    
    func getProposFromUser(user : Utilisateur) -> [Propos] {
        var proposList : [Propos] = []
        let url = URL(string : self.url + "users/propos")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.setValue(user.email, forHTTPHeaderField: "email")
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
                // Pour chaque propos dans le json, créee un propos et l'ajoute à la liste des propos
                for propos in json.arrayValue {
                    if let unPropos = self.decodePropos(propos: propos) {
                        proposList.append(unPropos)
                    }
                }
                
                semaphore.signal()
            }
            catch {
                print("JSON error: \(error.localizedDescription)")
            }
            
            
        }.resume()
        semaphore.wait()
        return proposList
        
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
                
                
                for rep in json["likesReponses"].arrayValue {
                    if let unPropos = self.decodePropos(propos: rep["propos"]) {
                        if let uneRep = self.decodeReponse(propos: unPropos, rep: rep) {
                            loggedUser!.reponsesLikes.append(uneRep)
                        }
                    }
                }
                
                for rep in json["dislikesReponses"].arrayValue {
                    if let unPropos = self.decodePropos(propos: rep["propos"]) {
                        if let uneRep = self.decodeReponse(propos: unPropos, rep: rep) {
                            loggedUser!.reponsesDislikes.append(uneRep)
                        }
                    }
                }
                
                for com in json["likesCommentaires"].arrayValue {
                    if let unPropos = self.decodePropos(propos: com["propos"]) {
                        if let unCom = self.decodeCommentaire(propos: unPropos, com: com) {
                            loggedUser!.commentairesLikes.append(unCom)
                        }
                    }
                }
                
                for com in json["dislikesCommentaires"].arrayValue {
                    if let unPropos = self.decodePropos(propos: com["propos"]) {
                        if let unCom = self.decodeCommentaire(propos: unPropos, com: com) {
                            loggedUser!.commentairesDislikes.append(unCom)
                        }
                    }
                }
                
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
    
    func updateAccount(email : String, pseudo : String, password : String) {
        let url = URL(string : self.url + "users/edit-infos")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "PUT"
        let putString = "email=\(email)&pseudo=\(pseudo)&password=\(password)"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
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
    
    func deleteAccount(email : String) {
        let url = URL(string : self.url + "users/delete-account")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "DELETE"
        let deleteString = "email=\(email)"
        request.httpBody = deleteString.data(using: String.Encoding.utf8)
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
    
    func actionReponse(reponse: Reponse, utilisateur: Utilisateur, action: String) {
        let url = URL(string : self.url + "reponses/" + action)
        guard let requestUrl = url else { fatalError() }
        
        var request = URLRequest(url: requestUrl)
        if action.hasPrefix("un") {
            request.httpMethod = "DELETE"
        } else {
            request.httpMethod = "PUT"
        }
        let putString = "reponseId=\(reponse.idC)"
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
    
    func actionCommentaire(commentaire: Commentaire, utilisateur: Utilisateur, action: String) {
        let url = URL(string : self.url + "commentaires/" + action)
        guard let requestUrl = url else { fatalError() }
        
        var request = URLRequest(url: requestUrl)
        if action.hasPrefix("un") {
            request.httpMethod = "DELETE"
        } else {
            request.httpMethod = "PUT"
        }
        let putString = "commentaireId=\(commentaire.idC)"
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
    
    func addCommentToPropos(propos : Propos, commentaire : String, createur : Utilisateur?) {
        print("id du propos : " + propos.idC)
        let url = URL(string : self.url + "propos/add-commentaire")
        guard let requestUrl = url else { fatalError() }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "PUT"
        print("contenu du commentaire : " + commentaire)
        let putString = "contenu=\(commentaire)&proposId=\(propos.idC)"
        if let user = createur {
            request.setValue(user.token, forHTTPHeaderField: "auth-token")
        }
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
    
    func addPropos(contenu : String, categorie : String, createur : Utilisateur?) -> Propos {
        let url = URL(string : self.url + "propos/create-propos")
        guard let requestUrl = url else { fatalError() }
        var propos : Propos? = nil
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        let semaphore = DispatchSemaphore(value : 0)
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
                guard let contenu = json["contenu"].string, let categorie = json["categorie"]["contenu"].string, let id = json["_id"].string else {
                           print("Erreur dans la structure du JSON")
                           return
                       }
                propos = Propos(contenu: contenu, categorie: categorie, createur: createur, likes: 0, reponses: [], commentaires: [], idC: id)
            }
            catch {
                print("JSON error: \(error.localizedDescription)")
            }
            semaphore.signal()
            
            
        }
        task.resume()
        semaphore.wait()
        return propos!
    }
    
    func addReponseToPropos(propos : Propos, contenu : String, categorie : String, createur : Utilisateur?) {
        print("id du propos : " + propos.idC)
        let url = URL(string : self.url + "propos/add-reponse")
        guard let requestUrl = url else {
            print("non")
            fatalError()
            
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "PUT"
        let putString = "contenu=\(contenu)&proposId=\(propos.idC)&categorie=\(categorie)"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        if let user = createur {
            request.setValue(user.token, forHTTPHeaderField: "auth-token")
        }
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
    
    func deletePropos(propos : Propos, createur : Utilisateur) {
        let url = URL(string : self.url + "propos/delete-propos")
        guard let requestUrl = url else { fatalError() }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "DELETE"
        let postString = "proposId=\(propos.idC)"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(createur.token, forHTTPHeaderField: "auth-token")
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
    
    func deleteReponse(reponse : Reponse, createur : Utilisateur) {
        let url = URL(string : self.url + "reponses/delete-reponse")
        guard let requestUrl = url else { fatalError() }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "DELETE"
        let postString = "reponseId=\(reponse.idC)"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(createur.token, forHTTPHeaderField: "auth-token")
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
    
    func deleteCommentaire(reponse : Commentaire, createur : Utilisateur) {
        let url = URL(string : self.url + "commentaires/delete-commentaire")
        guard let requestUrl = url else { fatalError() }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "DELETE"
        let postString = "commentaireId=\(reponse.idC)"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(createur.token, forHTTPHeaderField: "auth-token")
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
    
}

extension WebService {
    
    func decodePropos(propos: JSON) -> Propos? {
        let reponses = [Reponse]()
        let commentaires = [Commentaire]()
        // Récupération des données d'un propos
        guard let contenu = propos["contenu"].string, let categorie = propos["categorie"]["contenu"].string, let likes = propos["likes"].int, let id = propos["_id"].string, let datePropos = propos["created_at"].string else {
            print("Erreur dans la structure du JSON")
            return nil
        }
        // nil si le propos a été créé anonyment, ajout de l'utilisateur sinon
        var createur : Utilisateur? = nil
        if (propos["creator"]).exists() {
            createur = Utilisateur(pseudo: propos["creator"]["pseudo"].string!, email: propos["creator"]["email"].string!, password: "")
        }
        let date = datePropos.dateJSONToString()
        // Création du propos
        let unPropos : Propos = Propos(contenu: contenu, categorie: categorie, createur: createur, likes: likes, reponses: reponses, commentaires: commentaires, idC : id, date: date)


        
        
        for rep in propos["reponses"].arrayValue {
            if let reponse = decodeReponse(propos: unPropos, rep: rep) {
                unPropos.reponses.append(reponse)
            }
        }
        
        for com in propos["commentaires"].arrayValue {
            if let commentaire = (decodeCommentaire(propos: unPropos, com: com)) {
                unPropos.commentaires.append(commentaire)
            }
        }
        return unPropos
    }
    
    func decodeReponse(propos: Propos, rep: JSON) -> Reponse? {
        guard let contenu = rep["contenu"].string, let categorie = rep["categorie"]["contenu"].string, let likes = rep["likes"].int, let dislikes = rep["dislikes"].int, let idr = rep["_id"].string, let dateReponse = rep["created_at"].string else {
            print("Erreur dans la structure du JSON")
            return nil
        }
        // nil si le propos a été créé anonyment, ajout de l'utilisateur sinon
        var createur : Utilisateur? = nil
        if (rep["creator"]).exists() {
            createur = Utilisateur(pseudo: rep["creator"]["pseudo"].string!, email: rep["creator"]["email"].string!, password: "")
        }
        let date = dateReponse.dateJSONToString()
        // Création de la réponse et ajout à la liste des réponses du propos précédemment créé
        return Reponse(contenu: contenu, categorie: categorie, createur: createur, propos: propos, likes: likes, dislikes: dislikes, idC : idr, date: date)
    }
    
    func decodeCommentaire(propos: Propos, com: JSON) -> Commentaire? {
        // Récupération des données d'un commentaire
        guard let contenu = com["contenu"].string, let likes = com["likes"].int, let dislikes = com["dislikes"].int, let idc = com["_id"].string, let dateCommentaire = com["created_at"].string else {
            print("Erreur dans la structure du JSON")
            return nil
        }
        // nil si le propos a été créé anonyment, ajout de l'utilisateur sinon
        var createur : Utilisateur? = nil
        print(com)
        if (com["creator"]).exists() {
            createur = Utilisateur(pseudo: com["creator"]["pseudo"].string!, email: com["creator"]["email"].string!, password: "")
        }
        let date = dateCommentaire.dateJSONToString()
        // Création du commentaire et ajout à la liste des commentaires du propos précédemment créé
        return Commentaire(contenu: contenu, createur: createur, propos: propos, likes: likes, dislikes: dislikes, idC : idc, date: date)
    }
}

extension String {
    func dateJSONToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "dd/MM/yyyy"
        
        let date1 = formatter.date(from: self)
        let date2 = formatter2.string(from: date1!)
        return date2
    }
}

extension Date {
    static func dateToString(date : Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date = formatter.string(from: date)
        return date
    }
}
