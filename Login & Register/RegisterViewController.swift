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
    
    func setUI(){
        loginLabel.isUserInteractionEnabled = true
        let loginGesture = UITapGestureRecognizer(target: self, action: #selector(loginTapped))
        loginLabel.addGestureRecognizer(loginGesture)
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        
        if nameTextField.text != "" ||
            emailTextField.text != "" ||
            passwordTextField.text != "" ||
            confirmPasswordTextField.text != "" {
            if passwordTextField.text == confirmPasswordTextField.text {
                if let name = nameTextField.text,
                   let email = emailTextField.text,
                   let password = passwordTextField.text
                {
                    createUser(email: email, password: password, name: name)
                }
            }
            else {
                makeAlert(title: "Error", message: "Paswords don't match")
            }
        }
        else {
            makeAlert(title: "Error", message: "You should enter all information")
        }
        
    }
    
    @objc func loginTapped(){
        performSegue(withIdentifier: "registerToLogin", sender: nil)
    }
    
    func createUser(email: String, password: String, name: String){
        Auth.auth().createUser(withEmail: email, password: password) { auth, error in
            if let error = error {
                self.makeAlert(title: "Errro", message: error.localizedDescription)
            } else {
                let firestore = Firestore.firestore()
                let userDictionary = ["email" : email, "name": name] as [String : Any]
                firestore.collection("UserInfo").addDocument(data: userDictionary) { error in
                    if let error = error {
                        self.makeAlert(title: "Error", message: error.localizedDescription)
                    } else {
                        self.makeAlert(title: "Success", message: "Account registered successfully") { _ in
                            self.performSegue(withIdentifier: "registerToLogin", sender: nil)
                        }
                    }
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
