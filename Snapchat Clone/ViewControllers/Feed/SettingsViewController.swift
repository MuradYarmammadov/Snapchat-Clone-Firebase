//
//  SettingsViewController.swift
//  Snapchat Clone
//
//  Created by Murad Yarmamedov on 24.11.23.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    @IBAction func logOutButtonAction(_ sender: UIButton) {
        let currentUser = Auth.auth().currentUser
        
        if currentUser != nil  {
            do {
                try Auth.auth().signOut()
                self.makeAlert(title: "Success", message: "Log Out successfully. Press OK to continue") { _ in
                    self.performSegue(withIdentifier: "settingsToLogin", sender: nil)
                }
            } catch {
    
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
