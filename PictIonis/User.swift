//
//  User.swift
//  PictIonis
//
//  Created by Jeremy Debelleix on 11/07/2018.
//  Copyright © 2018 ETNA. All rights reserved.
//

import Foundation

class User {

    var id: String
    var login: String
    var win: Int
    var lose: Int

    init(id: String, login: String, win: Int, lose: Int) {

        self.id = id
        self.login = login
        self.win = win
        self.lose = lose

    }
}
