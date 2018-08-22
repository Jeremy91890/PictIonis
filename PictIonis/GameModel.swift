//
//  GameModel.swift
//  PictIonis
//
//  Created by Jeremy Debelleix on 22/08/2018.
//  Copyright © 2018 ETNA. All rights reserved.
//

import Foundation

class GameModel {

    var id: String
    var players: [String]
//    var player_2: User
//
    init(id: String, players: [String]) {

        self.id = id
        self.players = players

    }
}
