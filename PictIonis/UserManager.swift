//
//  UserManager.swift
//  PictIonis
//
//  Created by Jeremy Debelleix on 11/07/2018.
//  Copyright © 2018 ETNA. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseCore

class UserManager {

    //
    // MARK: - Properties
    //

    var db: Firestore!

    var ref: DatabaseReference!

    var users: [User] = []

    var onComplete: (() -> Void)?

    var onReceiveUser: ((_ user: User) -> Void)?

    var userCollection: CollectionReference!

    //
    // MARK: - SharedInstance
    //

    static let shared = UserManager()

    //
    // MARK: - Methods
    //

    init() {

        // [START setup]
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        // [END setup]

        db = Firestore.firestore()

        // Init collections
        self.userCollection = db.collection("user")
    }

    func load() {

        users.removeAll()

        self.userCollection.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {

                    let data = document.data()

                    let login = data["login"] as! String
                    let win = data["win"] as! Int
                    let lose = data["lose"] as! Int

                    let user = User.init(id: document.documentID, login: login, win: win, lose: lose)

                    self.users.append(user)
                }
                self.onComplete?()
            }
        }
    }

    func getUserBy(id: String) {

        log.debug(id)

        self.userCollection.whereField("id", isEqualTo: id).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for document in querySnapshot!.documents where document.documentID == id {

                    let data = document.data()
                    let login = data["login"] as! String
                    let win = data["win"] as! Int
                    let lose = data["lose"] as! Int

                    let user = User.init(id: id, login: login, win: win, lose: lose)
                    self.onReceiveUser?(user)

                }
            }

        }

    }

    func create(user: User) {

        self.userCollection.addDocument(data: [
            "login": user.login,
            "win": user.win,
            "lose": user.lose,
        ]) { err in
            if let err = err {
                log.debug("Error writing document: \(err)")
            } else {
                log.debug("Document successfully written!")
                self.load()
            }
        }

    }

    func set(user: User) {

        self.userCollection.document(user.id).setData([
            "login": user.login,
            "win": user.win,
            "lose": user.lose,
        ]) { err in
            if let err = err {
                log.debug("Error writing document: \(err)")
            } else {
                log.debug("Document successfully written!")
                self.load()
            }
        }

    }

    func remove(_ id: String) {

        self.userCollection.document(id).delete { err in
            if let err = err {
                log.debug("Error removing document: \(err)")
            }
            else {
                log.debug("Document successfully removed")
                self.load()
            }
        }
    }

}
