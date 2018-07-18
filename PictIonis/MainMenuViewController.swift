//
//  MainMenuViewController.swift
//  PictIonis
//
//  Created by Jeremy Debelleix on 10/07/2018.
//  Copyright © 2018 ETNA. All rights reserved.
//

import Foundation
import UIKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white

        self.view.addSubview(self.newGameButton)
        self.view.addSubview(self.gameSelectionButton)

        self.updateViewConstraints()
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()

        self.newGameButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.newGameButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.newGameButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        self.newGameButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true

        self.gameSelectionButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.gameSelectionButton.topAnchor.constraint(equalTo: self.newGameButton.bottomAnchor, constant: 10).isActive = true
        self.gameSelectionButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        self.gameSelectionButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true

    }

    @objc func newGameModal() {

        let newGame = NewGameViewController()
        self.show(newGame, sender: self)
    }

    @objc func gameSelectionModal() {

    }

    lazy var newGameButton: UIButton = {

        let button = UIButton()

        button.translatesAutoresizingMaskIntoConstraints = false

        button.backgroundColor = UIColor.green

        button.setTitle("Nouvelle partie", for: .normal)

        button.addTarget(self, action: #selector(newGameModal), for: .touchUpInside)

        return button
    }()

    lazy var gameSelectionButton: UIButton = {

        let button = UIButton()

        button.translatesAutoresizingMaskIntoConstraints = false

        button.backgroundColor = UIColor.blue

        button.setTitle("Parties en cours", for: .normal)

        button.addTarget(self, action: #selector(gameSelectionModal), for: .touchUpInside)

        return button
    }()
}
