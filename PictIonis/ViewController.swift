//
//  ViewController.swift
//  PictIonis
//
//  Created by Jeremy Debelleix on 06/07/2018.
//  Copyright © 2018 ETNA. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.lightGray

        self.view.addSubview(self.pictionisLabel)
        self.view.addSubview(self.facebookButton)
        self.view.addSubview(self.googleButton)
        self.view.addSubview(self.twitterButton)

        self.updateViewConstraints()
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()

        self.pictionisLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.pictionisLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        self.pictionisLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true

        self.googleButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.googleButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        self.facebookButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.facebookButton.rightAnchor.constraint(equalTo: self.googleButton.leftAnchor, constant: -10).isActive = true

        self.twitterButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.twitterButton.leftAnchor.constraint(equalTo: self.googleButton.rightAnchor, constant: 10).isActive = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    lazy var facebookButton: UIButton = {
        let button = UIButton()

        button.translatesAutoresizingMaskIntoConstraints = false

        button.setImage(UIImage(named: "facebook"), for: .normal)

        return button
    }()

    lazy var googleButton: UIButton = {
        let button = UIButton()

        button.translatesAutoresizingMaskIntoConstraints = false

        button.setImage(UIImage(named: "google"), for: .normal)

        return button
    }()

    lazy var twitterButton: UIButton = {
        let button = UIButton()

        button.translatesAutoresizingMaskIntoConstraints = false

        button.setImage(UIImage(named: "twitter"), for: .normal)

        return button
    }()

    lazy var pictionisLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false

        label.textColor = UIColor.yellow
        label.text = "PictIonis"
        label.font = label.font.withSize(70)
        label.textAlignment = .center

        return label
    }()

}

