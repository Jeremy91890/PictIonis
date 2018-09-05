//
//  GuessViewController.swift
//  PictIonis
//
//  Created by Jeremy Debelleix on 05/09/2018.
//  Copyright © 2018 ETNA. All rights reserved.
//

import Foundation
import UIKit

class GuessViewController: UIViewController {

    var gameID: String?

    convenience init(gameID: String) {
        self.init()

        self.gameID = gameID
        GameManager.shared.getDraw(gameID: self.gameID!)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.drawView)

        self.updateViewConstraints()

        self.drawView.lines = GameManager.shared.linesToDraw
        self.drawView.draw(self.drawView.frame)

        //GameManager.shared.getAddedDraws(gameID: self.gameID!)

        GameManager.shared.onReceiveLine = { lines in
            log.debug("Receive Lines \(lines)")
            self.drawView.lines = lines
            self.drawView.draw(self.drawView.frame)
        }

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
