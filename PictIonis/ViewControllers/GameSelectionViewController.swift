//
//  GameSelectionViewController.swift
//  PictIonis
//
//  Created by Jeremy Debelleix on 29/08/2018.
//  Copyright © 2018 ETNA. All rights reserved.
//

import Foundation
import UIKit

class GameSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView = UITableView()
    var games: [GameModel] = []
    var selectedGame = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.view.backgroundColor = UIColor.white
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        self.view.addSubview(tableView)
        self.view.addSubview(startButton)
        self.view.addSubview(playerLabel)

        self.tableView.translatesAutoresizingMaskIntoConstraints = false

        GameManager.shared.onReceiveUserGames = { games in
            log.debug("download users complete")
            self.games = games
            self.tableView.reloadData()
        }

        self.updateViewConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        GameManager.shared.loadUserGames()

    }

    override func updateViewConstraints() {
        super.updateViewConstraints()

        self.tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.tableView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5).isActive = true

        self.startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.startButton.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 10).isActive = true
        self.startButton.widthAnchor.constraint(equalTo: self.tableView.widthAnchor, multiplier: 0.7).isActive = true
        self.startButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true

        self.playerLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.playerLabel.bottomAnchor.constraint(equalTo: self.tableView.topAnchor, constant: -20).isActive = true

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.games.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell

        var gameName = "Partie avec: "

        for player in self.games[indexPath.row].players {
            gameName.append(player.id + " / ")
        }
        cell.textLabel?.text = gameName

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let cell = tableView.cellForRow(at: indexPath) {
            self.selectedGame = self.games[indexPath.row].id
            log.debug("selected game id => \(self.selectedGame)")
        }

    }

    lazy var playerLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Avec quel joueur voulez-vous jouer ?"

        return label
    }()

    lazy var startButton: UIButton = {
        let button = UIButton()

        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.green
        button.setTitle("Lancer la partie", for: .normal)
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)

        return button
    }()

    @objc func startGame() {

        GameManager.shared.startGame(id: self.selectedGame)
        //let game = GameModel.init(id: "1", players: ["2"])

        self.navigationController?.pushViewController(GuessViewController.init(gameID: self.selectedGame), animated: true)

    }

}