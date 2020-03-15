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
                print("appel à getPropos")
                let reponses = [Reponse]()
                let commentaires = [Commentaire]()
                for propos in json.arrayValue {
                    // Récupération des données d'un propos
                    guard let contenu = propos["contenu"].string, let categorie = propos["categorie"]["contenu"].string, let likes = propos["likes"].int, let id = propos["_id"].string else {
                        print("Erreur dans la structure du JSON")
                        return
                    }
                    // nil si le propos a été créé anonyment, ajout de l'utilisateur sinon
                    var createur : Utilisateur? = nil
                    if (propos["creator"]).exists() {
                        createur = Utilisateur(pseudo: propos["creator"]["pseudo"].string!, email: propos["creator"]["email"].string!, password: "")
                    }
                    // Création du propos
                    let unPropos : Propos = Propos(contenu: contenu, categorie: categorie, createur: createur, likes: likes, reponses: reponses, commentaires: commentaires, idC : id)
                    // Création des réponses associées au propos
                    for rep in propos["reponses"].arrayValue {
                        // Récupération des données d'une réponse
                        guard let contenu = rep["contenu"].string, let likes = rep["likes"].int, let dislikes = rep["dislikes"].int, let idr = rep["_id"].string else {
                            print("Erreur dans la structure du JSON")
                            return
                        }
                        // Création de la réponse et ajout à la liste des réponses du propos précédemment créé
                        // TODO récupérér catégorie rep["categorie"]["contenu"] -> trouver comment populate dans le serveur
                        let reponse = Reponse(contenu: contenu, categorie: "", createur: createur, propos: unPropos, likes: likes, dislikes: dislikes, idC : idr)
                        unPropos.reponses.append(reponse)
                    }
                    // Création des commentaires associés au propos
                    for com in propos["commentaires"].arrayValue {
                        // Récupération des données d'un commentaire
                        guard let contenu = com["contenu"].string, let likes = com["likes"].int, let dislikes = com["dislikes"].int, let idc = com["_id"].string else {
                            print("Erreur dans la structure du JSON")
                            return
                        }
                        // Création du commentaire et ajout à la liste des commentaires du propos précédemment créé
                        let commentaire = Commentaire(contenu: contenu, createur: createur, propos: unPropos, likes: likes, dislikes: dislikes, idC : idc)
                        unPropos.commentaires.append(commentaire)
                    }
                    
                    // Ajout du propos à la liste des propos
                    proposList.append(unPropos)
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
        print("token : " + token)
        let url = URL(string : self.url + "users")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "auth-token")
        var loggedUser : Utilisateur? = nil
        let semaphore = DispatchSemaphore(value : 0)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
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
                print(json)
                guard let pseudo = json.dictionaryValue["pseudo"]?.string, let email = json.dictionaryValue["email"]?.string else {
                    print("Wrong user informations")
                    return
                }
                loggedUser = Utilisateur(pseudo: pseudo, email: email, password: "")
                
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
    
    func login(email : String, password : String) -> Utilisateur? {
        let token = getTokenFromLoginInfos(email: email, password: password)
        print("AAAA" + token)
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
        var createdUser : Utilisateur? = nil
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
        print("utilisateur : \(getUserInfosFromToken(token: token))")
        return getUserInfosFromToken(token: token)
    }
    
    func addCommentToPropos(propos : Propos, commentaire : String) {
        print("id du propos : " + propos.idC)
        let url = URL(string : self.url + "propos/add-commentaire")        
        guard let requestUrl = url else { fatalError() }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "PUT"
        print("contenu du commentaire : " + commentaire)
        //let putString = "contenu=\(commentaire)&proposId=\(propos.idC)"
        var data : Dictionary<String, String> = ["contenu" : commentaire, "proposId" : propos.idC]
        request.httpBody = try? JSONSerialization.data(withJSONObject: data, options: [])
        //request.httpBody = putString.data(using: String.Encoding.utf8)
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
    
    //.buttonStyle(PlainButtonStyle)
}
