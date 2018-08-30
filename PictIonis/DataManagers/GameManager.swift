//
//  GameManager.swift
//  PictIonis
//
//  Created by Jeremy Debelleix on 22/08/2018.
//  Copyright © 2018 ETNA. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseCore

class GameManager {

    //
    // MARK: - Properties
    //

    var db: Firestore!

    var ref: DatabaseReference!

    var userId: String = UserDefaults.standard.value(forKey: "uid") as! String

    var userGames: [GameModel] = []

    var onComplete: (() -> Void)?

    var onReceiveLine: ((_ lines: [Line]) -> Void)?

    var onReceiveUser: ((_ user: User) -> Void)?

    var userCollection: CollectionReference!
    var gameCollection: CollectionReference!

    //
    // MARK: - SharedInstance
    //

    static let shared = GameManager()

    //
    // MARK: - Methods
    //

    init() {

        log.debug("Init")

        ref = Database.database().reference()

        self.load()

    }

    func load() {

        ref.child("games").observe(.value, with: { snapshot in
            log.debug(snapshot)
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {

                for child in snapshots {

                    let id = child.key
                    //let adversaire = child.childSnapshot(forPath: "adversaire").value as! String
                    //                    let win = child.childSnapshot(forPath: "win").value as! Int
                    //                    let lose = child.childSnapshot(forPath: "lose").value as! Int

                    let players: [String] = []
//                    for player in child.childSnapshot(forPath: players) {
//                        players.append(<#T##newElement: Any##Any#>)
//                    }
                    let game = GameModel.init(id: id, players: players)

                    self.userGames.append(game)

                }
                self.onComplete?()
            }
        })

    }

    func getGameBy(id: String) {

        log.debug(id)

        self.gameCollection.whereField("id", isEqualTo: id).getDocuments { (querySnapshot, err) in
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

    func addLine(line: Line, game: GameModel) {
       // self.ref.child("games/\(game.id)/currentDraw").
        let point = self.ref.child("games/\(game.id)/currentDraw").childByAutoId()

        point.child("start_x").setValue(line.start.x)
        point.child("start_y").setValue(line.start.y)
        point.child("end_x").setValue(line.end.x)
        point.child("end_y").setValue(line.end.y)

    }

    func getDraw(game: GameModel) -> [Line] {

        var lines: [Line] = []

        ref.child("games/\(game.id)/currentDraw").observe(.value, with: { snapshot in
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {

                for child in snapshots {

                    let id = child.key

                    let start_x = child.childSnapshot(forPath: "start_x").value as! Int
                    let start_y = child.childSnapshot(forPath: "start_y").value as! Int
                    let end_x = child.childSnapshot(forPath: "end_x").value as! Int
                    let end_y = child.childSnapshot(forPath: "end_y").value as! Int

                    let line = Line.init(start: CGPoint.init(x: start_x, y: start_y), end: CGPoint.init(x: end_x, y: end_y))

                    lines.append(line)
                }
                self.onReceiveLine?(lines)
            }
        })

        return lines
    }

    func create(players: [String]) -> GameModel {

        let newGame = self.ref.child("games").childByAutoId()

        for player in players {
            newGame.child("\(player)/isDrawing").setValue(false)
            newGame.child("\(player)/nbDraw").setValue(0)
            newGame.child("\(player)/points").setValue(0)

        }

        let gameModel = GameModel.init(id: newGame.key, players: <#T##[String]#>)

     //   self.ref.child("games/\(game.id)/login").setValue("hello test game")
//        self.ref.child("user/\(user.id)/win").setValue(0)
//        self.ref.child("user/\(user.id)/lose").setValue(0)
    }

//    func set(game: GameModel) {
//
//        self.gameCollection.document(game.id).setData([
//            "login": user.login,
//            "win": user.win,
//            "lose": user.lose,
//            ]) { err in
//                if let err = err {
//                    log.debug("Error writing document: \(err)")
//                } else {
//                    log.debug("Document successfully written!")
//                    self.load()
//                }
//        }
//
//    }

    func remove(_ id: String) {

        self.gameCollection.document(id).delete { err in
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
