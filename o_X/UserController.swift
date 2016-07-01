//
//  UserController.swift
//  o_X
//
//  Created by David Xu on 6/30/16.
//  Copyright © 2016 iX. All rights reserved.
//

import Foundation
class UserController {
    
    static var sharedInstance = UserController()
    private init() {}
    
    var userList = [User]()
    var currentUser: User?
    
    func register(email email: String, password: String, onCompletion: (User? ,String?) -> Void) {
        
        for user in userList{
            if user.email == email {
                onCompletion(nil, "The email is alreayd in use.")
                return
            }
        }
        
        if (password.characters.count < 6){
            onCompletion(nil, "Passwords must be at least 6 characters long.")
            return
        }
            
       
        currentUser = User(email: email, password: password)
        userList.append(currentUser!)
        onCompletion(currentUser, nil)
    }
    
    func login(email email:String, password:String,onCompletion:(User?,String?) -> Void) {
        for user in userList {
            if user.email == email && user.password == password {
                currentUser = user
                onCompletion(user, "Log in succeed")
                return
            }
        }
        
        onCompletion(nil, "Your username or password is incorrect")
        return
    }
    func logout(onCompletion onCompletion: (String?) -> Void){
        currentUser = nil
        onCompletion(nil)
    }
}