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

    var gameID: String?
    
    convenience init(gameID: String) {
        self.init()

        self.gameID = gameID
       // GameManager.shared.getDraw(gameID: self.gameID!)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.drawView)

        drawView.delegate = self
        
        self.updateViewConstraints()

//        GameManager.shared.onReceiveGame = { game in
//            log.debug("On receive game")
//            self.gameID = gameID
//            GameManager.shared.getDraw(gameID: self.gameID!)
//        }

//        GameManager.shared.onReceiveLine = { lines in
//            self.drawView.lines = lines
//            self.drawView.draw(self.drawView.frame)
//        }

    }

    override func updateViewConstraints() {
        super.updateViewConstraints()

        self.drawView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.drawView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.drawView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.drawView.heightAnchor.constraint(equalToConstant: 500).isActive = true

    }

    lazy var drawView: DrawView = {

        let drawView = DrawView()

        drawView.translatesAutoresizingMaskIntoConstraints = false

        return drawView
    }()

}

extension GameViewController: DrawViewDelegate {

    func addLine(line: Line) {

        GameManager.shared.addLine(line: line, gameID: self.gameID!)
    }

}
