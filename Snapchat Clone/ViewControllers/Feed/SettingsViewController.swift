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
        self.makeAlert(title: "Success", message: "Log out successfully. Press OK to continue") { _ in
            do{
                try Auth.auth().signOut()
                self.performSegue(withIdentifier: "settingsToLogin", sender: nil)
            } catch {
             //
            }
        }
    }
    
}
