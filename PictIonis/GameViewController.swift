//
//  GameViewController.swift
//  PictIonis
//
//  Created by Jeremy Debelleix on 22/08/2018.
//  Copyright © 2018 ETNA. All rights reserved.
//

import Foundation
import UIKit

class GameViewController: UIViewController {

    var game: GameModel!
    

    convenience init(game: GameModel) {
        self.init()

        self.game = game

         GameManager.shared.create(game: game)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.drawView)

        self.updateViewConstraints()
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()

        self.drawView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.drawView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.drawView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.drawView.heightAnchor.constraint(equalToConstant: 500).isActive = true


    }

    lazy var drawView: UIView = {

        let drawView = DrawView()

        drawView.translatesAutoresizingMaskIntoConstraints = false

        return drawView
    }()


}
