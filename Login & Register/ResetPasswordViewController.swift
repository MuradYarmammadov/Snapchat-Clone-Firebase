//
//  ResetPasswordViewController.swift
//  Snapchat Clone
//
//  Created by Murad Yarmamedov on 24.11.23.
//

import UIKit
import FirebaseAuth

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var signUpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
   private func setUI(){
        loginLabel.isUserInteractionEnabled = true
        let loginGesture = UITapGestureRecognizer(target: self, action: #selector(loginTapped))
        loginLabel.addGestureRecognizer(loginGesture)
        
        signUpLabel.isUserInteractionEnabled = true
        let signUpGesture = UITapGestureRecognizer(target: self, action: #selector(signUpTapped))
        signUpLabel.addGestureRecognizer(signUpGesture)
    }

    @IBAction func sendButtonAction(_ sender: UIButton) {
        if emailTextField.text != "" {
            if let email = emailTextField.text{
                Auth.auth().sendPasswordReset(withEmail: email)
            }
        } else {
            makeAlert(title: "Error", message: "Email is required")
        }
    }
    
    @objc func loginTapped(){
        performSegue(withIdentifier: "resetToLogin", sender: nil)
    }
    
    @objc func signUpTapped() {
        performSegue(withIdentifier: "resetToRegister", sender: nil)
    }

}
