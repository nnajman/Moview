//
//  ModelFirebase.swift
//  Moview
//
//  Created by admin on 13/07/2021.
//

import Foundation
import Firebase

class ModelFirebase {
    let usersCollection = "users"

    func saveImage(image: UIImage, path: String, filename: String, callback:@escaping (String)->Void) {
        let imageRef = Storage.storage().reference().child(path).child(filename)
        let data = image.jpegData(compressionQuality: 0.8)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(data!, metadata: metadata) { (metadata, error) in
            imageRef.downloadURL { (url, error) in
                guard let downloadUrl = url else {
                    callback("")
                    return
                }
                
                callback(downloadUrl.absoluteString)
            }
        }
    }
    
    func addUser(user: User, callback:@escaping (Bool)->Void) {
        let db = Firestore.firestore()
        db.collection(usersCollection).document(user.id!).setData(user.toJson()) { err in
            if let err = err {
                callback(false)
            }
            else {
                callback(true)
            }
        }
    }
    
    func getAllUsers(lastUpdate: Int64, callback:@escaping ([User])->Void){
        let db = Firestore.firestore()
        db.collection(usersCollection)
            .whereField("lastUpdated", isGreaterThan: Timestamp(seconds: lastUpdate, nanoseconds: 0))
            .getDocuments { snapshot, error in
            if let error = error {
                print("Error reading document: \(error)")
            }
            else {
                if let snapshot = snapshot {
                    var data = [User]()
                    for doc in snapshot.documents {
                        if let user = User.create(json: doc.data()) {
                            data.append(user)
                        }
                    }
                    
                    callback(data)
                    return
                }
            }
            
            callback([User]())
        }
    }

}
