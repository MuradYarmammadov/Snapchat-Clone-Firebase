//
//  AlertExtension.swift
//  Snapchat Clone
//
//  Created by Murad Yarmamedov on 01.12.23.
//

import Foundation
import UIKit

extension UIViewController {
    func makeAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: handler)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
