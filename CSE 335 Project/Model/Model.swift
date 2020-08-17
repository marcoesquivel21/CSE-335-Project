//
//  Model.swift
//  CSE 335 Project
//
//  Created by Marco Esquivel on 3/21/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

//MODEL WITH FIREBASE
let db = Firestore.firestore()

public struct MyHike: Codable{
    var name:String
    var distance:String
    var difficulty:String
    var route:String
    var rating:String
    var journalEntry:String
    //for now this will be image url
    let image:Data?
    //let imagesRef = storageRef.child("images")

    
}

public struct NearbyHikes{
    var nearbyList:[String] = [String]()
}

public class User{
    
    var hikeList:[MyHike] = [MyHike]()
    init() {}
        
        
        
    func onLoad(){
        db.collection("user").getDocuments { (snapshot, error) in
            if let error = error {
              print(error)
            } else if let snapshot = snapshot {
                let tempHikes = snapshot.documents.compactMap {
                    return try? $0.data(as: MyHike.self)
                }
                self.setArray(h: tempHikes)
                self.printHikes()
            }
        }
        
    }
    
    func printHikes(){
        for h in hikeList{
            print(h.name)
        }
    }
    
    func setArray(h : [MyHike]){
        hikeList = h
        print(hikeList.count)
    }
    
    func addHike(h: MyHike){
        do {
            try db.collection("user").document(h.name).setData(from: h)
        } catch let error {
            print(error)
        }
    }
    
    func removeHike(h: MyHike){
        db.collection("user").document(h.name).delete(){ err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
    }
    
    func removeHikeLocal(index: Int){
        hikeList.remove(at: index)
    }
    
    func editHikeDB(h: MyHike){
        do {
            try db.collection("user").document(h.name).setData(from: h)
        } catch let error {
            print(error)
        }
    }
    
    func editHikeLocal(index: Int, h: MyHike){
        hikeList[index].name = h.name
        hikeList[index].distance = h.distance
        hikeList[index].difficulty = h.difficulty
        hikeList[index].rating = h.rating
        hikeList[index].route = h.route
        hikeList[index].journalEntry = h.journalEntry
    }
    
}

public class APIModel{
    let url = "https://type.fit/api/quotes"
    var num = 0;
    
    func getQuotes(completion: @escaping (Result<[quote], Error>) -> Void){
         guard let resourceURL = URL(string: url) else{fatalError()}
        let dataTask = URLSession.shared.dataTask(with: resourceURL){(data, response, error) in
            guard let jsonData = data else{
                completion(.failure(error!))
                return
            }
            
            do{
                let q = try JSONDecoder().decode([quote].self, from: jsonData)
                self.num = Int.random(in: 0..<q.count)
                completion(.success(q))
            }catch{
                completion(.failure(error))
            }
            
            

        }
        dataTask.resume()
    }
}

struct quote:Decodable{
    let text:String?
    let author:String?
}


