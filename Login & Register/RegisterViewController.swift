//
//  RegisterViewController.swift
//  Snapchat Clone
//
//  Created by Murad Yarmamedov on 24.11.23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore


class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var loginLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    private func setUI(){
        loginLabel.isUserInteractionEnabled = true
        let loginGesture = UITapGestureRecognizer(target: self, action: #selector(loginTapped))
        loginLabel.addGestureRecognizer(loginGesture)
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        if nameTextField.text != "" &&
            emailTextField.text != "" &&
            passwordTextField.text != "" &&
            confirmPasswordTextField.text != "" {
            if passwordTextField.text == confirmPasswordTextField.text {
                if let email = emailTextField.text,
                   let name = nameTextField.text,
                   let password = passwordTextField.text {
                    self.createUser(email: email, password: password, name: name)
                }
            } else {
                self.makeAlert(title: "Error", message: "Passwords not matched")
            }
        } else {
            self.makeAlert(title: "Error", message: "Enter all information")
        }
    }
    
    @objc func loginTapped(){
        performSegue(withIdentifier: "registerToLogin", sender: nil)
    }
    
    func createUser(email: String, password: String, name: String){
        Auth.auth().createUser(withEmail: email, password: password) { auth, error in
            if let error = error {
                self.makeAlert(title: "Error", message: error.localizedDescription)
            } else {
                let fireStore = Firestore.firestore()
                let userDictionary = ["Email": email, "Name": name] as [String: Any]
                fireStore.collection("UserInfo").addDocument(data: userDictionary) { error in
                    if let error = error {
                        self.makeAlert(title: "Error", message: error.localizedDescription)
                    } else {
                        self.makeAlert(title: "Success", message: "Account was created successfully") { _ in
                            self.performSegue(withIdentifier: "registerToLogin", sender: nil)
                        }
                    }
                }
            }
        }
        
    }

}
