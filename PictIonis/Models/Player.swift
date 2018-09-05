//
//  Player.swift
//  PictIonis
//
//  Created by Jeremy Debelleix on 05/09/2018.
//  Copyright © 2018 ETNA. All rights reserved.
//

import Foundation

class Player {

    var id: String
    var isDrawing: Bool
    var nbDraw: Int
    var points: Int

    init(id: String, isDrawing: Bool, nbDraw: Int, points: Int) {

        self.id = id
        self.isDrawing = isDrawing
        self.nbDraw = nbDraw
        self.points = points

    }
}
