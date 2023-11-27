//
//  UserSingleton.swift
//  Snapchat Clone
//
//  Created by Murad Yarmamedov on 24.11.23.
//

import Foundation

class UserSingleton {
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var name = ""
    
    private init(){
        
    }
}
