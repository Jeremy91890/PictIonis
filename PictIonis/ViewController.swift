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
import FacebookLogin
import FacebookCore
import FBSDKLoginKit
import GoogleSignIn
import TwitterKit

class ViewController: UIViewController, GIDSignInUIDelegate {

    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.lightGray

        self.view.addSubview(self.pictionisLabel)
        self.view.addSubview(self.facebookButton)
        self.view.addSubview(self.googleButton)
        self.view.addSubview(self.twitterButton)

        self.view.addSubview(self.mailTextField)
        self.view.addSubview(self.passwordTextField)
        self.view.addSubview(self.errorLabel)

        self.view.addSubview(self.signInButton)
        self.view.addSubview(self.signUpButton)

        self.updateViewConstraints()

        // Notify when keyboard appears
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        self.updateViewConstraints()

        // [START setup]
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()

        GIDSignIn.sharedInstance().uiDelegate = self

    }

    override func updateViewConstraints() {
        super.updateViewConstraints()

        self.pictionisLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.pictionisLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        self.pictionisLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true

        self.googleButton.centerYAnchor.constraint(equalTo: self.pictionisLabel.bottomAnchor, constant: 100).isActive = true
        self.googleButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        self.facebookButton.centerYAnchor.constraint(equalTo: self.googleButton.centerYAnchor).isActive = true
        self.facebookButton.rightAnchor.constraint(equalTo: self.googleButton.leftAnchor, constant: -10).isActive = true

        self.twitterButton.centerYAnchor.constraint(equalTo: self.googleButton.centerYAnchor).isActive = true
        self.twitterButton.leftAnchor.constraint(equalTo: self.googleButton.rightAnchor, constant: 10).isActive = true

        self.mailTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.mailTextField.topAnchor.constraint(equalTo: self.googleButton.bottomAnchor, constant: 30).isActive = true
        self.mailTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.mailTextField.heightAnchor.constraint(equalToConstant: 56).isActive = true

        self.passwordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.passwordTextField.topAnchor.constraint(equalTo: self.mailTextField.bottomAnchor, constant: 20).isActive = true
        self.passwordTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.passwordTextField.heightAnchor.constraint(equalToConstant: 56).isActive = true

        self.errorLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.errorLabel.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 20).isActive = true

        self.signUpButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 100).isActive = true
        self.signUpButton.topAnchor.constraint(equalTo: self.errorLabel.bottomAnchor, constant: 5).isActive = true
        self.signUpButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        self.signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        self.signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -100).isActive = true
        self.signInButton.topAnchor.constraint(equalTo: self.errorLabel.bottomAnchor, constant: 5).isActive = true
        self.signInButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        self.signInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    lazy var facebookButton: UIButton = {
        let button = UIButton()

        button.translatesAutoresizingMaskIntoConstraints = false

        button.setImage(UIImage(named: "facebook"), for: .normal)

        button.addTarget(self, action: #selector(self.facebookLogin), for: .touchUpInside)

        return button
    }()

    lazy var googleButton: UIButton = {
        let button = UIButton()

        button.translatesAutoresizingMaskIntoConstraints = false

        button.setImage(UIImage(named: "google"), for: .normal)

        button.addTarget(self, action: #selector(self.googleLogin), for: .touchUpInside)

        return button
    }()

    lazy var twitterButton: UIButton = {
        let button = UIButton()

        button.translatesAutoresizingMaskIntoConstraints = false

        button.setImage(UIImage(named: "twitter"), for: .normal)

        button.addTarget(self, action: #selector(self.twitterLogin), for: .touchUpInside)

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

    lazy var mailTextField: UITextField = {

        let textField = UITextField()

        textField.placeholder = "email"

        textField.translatesAutoresizingMaskIntoConstraints = false

        textField.textColor = UIColor.gray

        textField.textAlignment = NSTextAlignment.center

        textField.backgroundColor = UIColor.white

        textField.layer.cornerRadius = 28

        textField.keyboardType = .emailAddress

        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no

        return textField
    }()

    lazy var passwordTextField: UITextField = {

        let textField = UITextField()

        textField.placeholder = "Mot de passe"

        textField.translatesAutoresizingMaskIntoConstraints = false

        textField.textAlignment = NSTextAlignment.center

        textField.backgroundColor = UIColor.white

        textField.textColor = UIColor.gray

        textField.layer.cornerRadius = 28

        textField.isSecureTextEntry = true

        textField.keyboardType = .emailAddress

        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no

        return textField
    }()

    lazy var errorLabel: UILabel = {

        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false

        label.textColor = UIColor.red

        return label
    }()

    lazy var signInButton: UIButton = {

        let button = UIButton()

        button.backgroundColor = UIColor.cyan

        button.setTitle("Se connecter", for: .normal)

        button.layer.cornerRadius = 25

        button.translatesAutoresizingMaskIntoConstraints = false

        button.addTarget(self, action: #selector(self.authenticateByMail), for: .touchUpInside)

        return button
    }()

    lazy var signUpButton: UIButton = {

        let button = UIButton()

        button.backgroundColor = UIColor.green

        button.layer.cornerRadius = 25

        button.setTitle("Créer le compte", for: .normal)

        button.translatesAutoresizingMaskIntoConstraints = false

        button.addTarget(self, action: #selector(self.signUpByMail), for: .touchUpInside)

        return button
    }()

    @objc func authenticateByMail() {

        guard var email = self.mailTextField.text, self.mailTextField.text != "" else {
            log.error("email field is empty")
            self.errorLabel.text = "Adresse mail non valide"
            return
        }

        guard let password = self.passwordTextField.text, self.passwordTextField.text != "" else {
            log.error("password field is empty")
            self.errorLabel.text = "Mot de passe non valide"
            return
        }

        email = email.trimmingCharacters(in: .whitespaces)

        Auth.auth().signIn(withEmail: email, password: password) { (userInfo, error) in

            guard let userInfo = userInfo else {
                log.error(error)
                self.errorLabel.text = "Mauvais identifiants saisis"
                return
            }

            //self.launchMainMenu(user: userInfo.user, connectionWay: "email")

        }

    }

    @objc func signUpByMail() {

        guard var email = self.mailTextField.text, self.mailTextField.text != "" else {
            log.error("email field is empty")
            self.errorLabel.text = "Adresse mail non valide"
            return
        }

        guard let password = self.passwordTextField.text, self.passwordTextField.text != "" else {
            log.error("password field is empty")
            self.errorLabel.text = "Mot de passe non valide"
            return
        }

        email = email.trimmingCharacters(in: .whitespaces)

        Auth.auth().createUser(withEmail: email, password: password) { (userInfo, error) in

            guard let userInfo = userInfo else {
                log.error(error)
                self.errorLabel.text = "Mauvais identifiants saisis"
                return
            }

           // self.launchMainMenu(user: userInfo.user, connectionWay: "email")

        }

    }

    @objc func googleLogin() {

        log.debug("google button pressed")
        // Google+ signIn
        GIDSignIn.sharedInstance().signIn()

    }

    // Launch facebook connection page
    @objc func facebookLogin() {

        let loginManager = LoginManager()

        loginManager.logIn(readPermissions: [.publicProfile], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                log.error(error)
            case .cancelled:
                log.debug("User cancelled login.")
            case .success:
                self.facebookFirebaseAuth()
            }
        }

    }

    // Connect facebook with firebase
    private func facebookFirebaseAuth() {

        log.debug("Facebook Firebase Auth")

        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)

        Auth.auth().signInAndRetrieveData(with: credential) { (userInfo, error) in

            guard let user = userInfo?.user else {
                log.error(error)
                return
            }

            //self.launchMainMenu(user: user, connectionWay: "Facebook")

        }

    }

    // Launch twitter connection page
    @objc func twitterLogin() {

        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
            if session != nil {
                self.twitterFirebaseAuth(session!)
            } else {
                log.debug("error: \(String(describing: error?.localizedDescription))")
            }
        })

    }

    // Twitter Connection with firebase
    private func twitterFirebaseAuth(_ session: TWTRSession) {

        let credential = TwitterAuthProvider.credential(withToken: session.authToken, secret: session.authTokenSecret)

        Auth.auth().signInAndRetrieveData(with: credential) { (userInfo, error) in

            guard let user = userInfo?.user else {
                log.error(error)
                return
            }

          //  self.launchMainMenu(user: user, connectionWay: "Twitter")

        }

    }


}

