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
    
   private func setUI(){
        createNewAccountLabel.isUserInteractionEnabled = true
        let createAccountGesture = UITapGestureRecognizer(target: self, action: #selector(createAccountTapped))
        createNewAccountLabel.addGestureRecognizer(createAccountGesture)
        
        forgotPasswordLabel.isUserInteractionEnabled = true
        let forgotPasswordGesture = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordTapped))
        forgotPasswordLabel.addGestureRecognizer(forgotPasswordGesture)
    }

    @IBAction func loginButtonAction(_ sender: UIButton) {
        if emailTextField.text != "" &&
            passwordTextField.text != "" {
            if let password = passwordTextField.text,
               let email = emailTextField.text {
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
                self.makeAlert(title: "Success", message: "Acount login successfully. Press OK to continue") { _ in
                    self.performSegue(withIdentifier: "loginToFeed", sender: nil)
                }
            }
        }
    }
}

