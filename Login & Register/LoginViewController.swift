//
//  ViewController.swift
//  Snapchat Clone
//
//  Created by Murad Yarmamedov on 24.11.23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createNewAccountLabel: UILabel!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    func setUI(){
        createNewAccountLabel.isUserInteractionEnabled = true
        let createAccountGesture = UITapGestureRecognizer(target: self, action: #selector(createAccountTapped))
        createNewAccountLabel.addGestureRecognizer(createAccountGesture)
        
        forgotPasswordLabel.isUserInteractionEnabled = true
        let forgotPasswordGesture = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordTapped))
        forgotPasswordLabel.addGestureRecognizer(forgotPasswordGesture)
    }

    @IBAction func loginButtonAction(_ sender: UIButton) {
        if emailTextField.text != "" ||
            passwordTextField.text != "" {
            if let email = emailTextField.text,
               let password = passwordTextField.text {
                login(email: email, password: password)
            }
        } else {
            self.makeAlert(title: "Error", message: "Enter all information")
        }
    }
    
    @objc func createAccountTapped() {
        performSegue(withIdentifier: "loginToRegister", sender: nil)
    }
    
    @objc func forgotPasswordTapped(){
        performSegue(withIdentifier: "loginToReset", sender: nil)
    }
    
    func login(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.makeAlert(title: "Error", message: error.localizedDescription)
            } else {
                self.makeAlert(title: "Success", message: "Press Ok to finished Login process") { _ in
                    self.performSegue(withIdentifier: "loginToFeed", sender: nil)
                }
            }
        }
    }
    
    func makeAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: handler)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

