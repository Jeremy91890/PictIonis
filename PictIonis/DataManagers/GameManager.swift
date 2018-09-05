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

    var onReceiveGame: ((_ game: GameModel) -> Void)?

    var onReceiveUserGames: ((_ game: [GameModel]) -> Void)?

    var gameById: GameModel?
    //var onReceiveUser: ((_ user: User) -> Void)?

    var userCollection: CollectionReference!
    var gameCollection: CollectionReference!

    var currentGame: String?

    var linesToDraw: [Line] = []

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

    }

    func loadUserGames() {

        log.debug("LOAD")
        ref.child("games").observe(.value, with: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {

                var games: [GameModel] = []

                for child in snapshots {

                    let id = child.key
                    var players: [Player] = []

                    self.ref.child("games/\(id)/players").observe(.value, with: { snapshot in

                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {

                            for child in snapshots {

                                log.debug("child in get game by id\(child)")

                                let id = child.key

                                guard let nbDraw = child.childSnapshot(forPath: "nbDraw").value as? Int else {
                                    return
                                }

                                guard let isDrawing = child.childSnapshot(forPath: "isDrawing").value as? Bool else {
                                    return
                                }

                                guard let points = child.childSnapshot(forPath: "points").value as? Int else {
                                    return
                                }


                                let player = Player.init(id: id, isDrawing: isDrawing, nbDraw: nbDraw, points: points)

                                players.append(player)

                            }

                            let game = GameModel.init(id: id, players: players)
                            games.append(game)
                        }

                        self.onReceiveUserGames!(games)

                    })

                }

            }
        })

    }

    func startGame(id: String) {

        var players: [Player] = []

        ref.child("games/\(id)/players").observe(.value, with: { snapshot in

            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {

                log.debug("get game \(snapshots)")
                for child in snapshots {

                    log.debug("child in get game by id\(child)")
                    //let id = child.key

                    let id = child.key

                    guard let nbDraw = child.childSnapshot(forPath: "nbDraw").value as? Int else {
                        return
                    }

                    guard let isDrawing = child.childSnapshot(forPath: "isDrawing").value as? Bool else {
                        return
                    }

                    guard let points = child.childSnapshot(forPath: "points").value as? Int else {
                        return
                    }

                    let player = Player.init(id: id, isDrawing: isDrawing, nbDraw: nbDraw, points: points)

                    players.append(player)
                    
                }

            }

            let game = GameModel.init(id: id, players: players)

            self.onReceiveGame?(game)

        })

    }

    func addLine(line: Line, gameID: String) {
        let point = self.ref.child("games/\(gameID)/currentDraw").childByAutoId()

        point.child("start_x").setValue(line.start.x)
        point.child("start_y").setValue(line.start.y)
        point.child("end_x").setValue(line.end.x)
        point.child("end_y").setValue(line.end.y)

    }

//    func getAddedDraws(gameID: String) {
//
//        var lines: [Line] = []
//
//        log.debug("game Id \(gameID)")
//        ref.child("games/\(gameID)/currentDraw").observe(.childAdded, with: { snapshot in
//
//            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
//
//                log.debug("draw snapshot \(snapshots)")
//                for child in snapshots {
//
//                    log.debug("draw snapshot child \(child)")
//                    //let id = child.key
//
//                    log.debug("draw snapshot child \(child)")
//                    //let id = child.key
//                    guard let start_x = child.childSnapshot(forPath: "start_x").value as? Double else {
//                        return
//                    }
//                    guard let start_y = child.childSnapshot(forPath: "start_y").value as? Double else {
//                        return
//                    }
//                    guard let end_x = child.childSnapshot(forPath: "end_x").value as? Double else {
//                        return
//                    }
//                    guard let end_y = child.childSnapshot(forPath: "end_y").value as? Double else {
//                        return
//                    }
//
//                    let line = Line.init(start: CGPoint.init(x: start_x, y: start_y), end: CGPoint.init(x: end_x, y: end_y))
//
//                    lines.append(line)
//                    self.onReceiveLine?(lines)
//
//                }
//            }
//        })
//    }

    func getDraw(gameID: String) {

        log.debug("game Id \(gameID)")

        ref.child("games/\(gameID)/currentDraw").observe(.value, with: { (snapshot) -> Void in
            var lines: [Line] = []

            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {

                log.debug("draw snapshot \(snapshots)")
                for child in snapshots {

                    log.debug("draw snapshot child \(child)")
                    //let id = child.key
                    guard let start_x = child.childSnapshot(forPath: "start_x").value as? Double else {
                        return
                    }
                    guard let start_y = child.childSnapshot(forPath: "start_y").value as? Double else {
                        return
                    }
                    guard let end_x = child.childSnapshot(forPath: "end_x").value as? Double else {
                        return
                    }
                    guard let end_y = child.childSnapshot(forPath: "end_y").value as? Double else {
                        return
                    }

                    let line = Line.init(start: CGPoint.init(x: start_x, y: start_y), end: CGPoint.init(x: end_x, y: end_y))

                    lines.append(line)
                }

            }
            self.linesToDraw = lines
            self.onReceiveLine?(self.linesToDraw)

        })

    }

    func create(playersID: [String]) {

        log.debug("create")
        var players: [Player] = []

        let newGame = self.ref.child("games").childByAutoId()
        self.currentGame = newGame.key

        players.append(Player.init(id: self.userId, isDrawing: true, nbDraw: 0, points: 0))

        for player in playersID {
            players.append(Player.init(id: player, isDrawing: false, nbDraw: 0, points: 0))
        }

        for player in players {
            newGame.child("/players/\(player.id)/points").setValue(player.points)
            newGame.child("/players/\(player.id)/isDrawing").setValue(player.isDrawing)
            newGame.child("/players/\(player.id)/nbDraw").setValue(player.nbDraw)
        }

        let gameModel = GameModel.init(id: newGame.key, players: players)


        self.onReceiveGame?(gameModel)

    }

    func remove(_ id: String) {

        self.gameCollection.document(id).delete { err in
            if let err = err {
                log.debug("Error removing document: \(err)")
            }
            else {
                log.debug("Document successfully removed")
               // self.load()
            }
        }
    }

    // TODO Get game by id, quand on rejoind une partie

}
