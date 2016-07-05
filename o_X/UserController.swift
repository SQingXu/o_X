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
    let defaults = NSUserDefaults.standardUserDefaults()
    
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
        defaults.setObject(email, forKey: "CurrentUserEmail")
        defaults.setObject(password, forKey: "CurrentUserPassword")
        userList.append(currentUser!)
        onCompletion(currentUser, nil)
        defaults.synchronize()
    }
    
    func login(email email:String, password:String,onCompletion:(User?,String?) -> Void) {
        for user in userList {
            if user.email == email && user.password == password {
                currentUser = user
                
                defaults.setObject(email, forKey: "CurrentUserEmail")
                defaults.setObject(password, forKey: "CurrentUserPassword")

                onCompletion(user, "Log in succeed")
                defaults.synchronize()
                return
            }
        }
        
        onCompletion(nil, "Your username or password is incorrect")
        return
    }
    func logout(onCompletion onCompletion: (String?) -> Void){
        
        defaults.setObject(nil, forKey: "CurrentUserEmail")
        defaults.setObject(nil, forKey: "CurrentUserPassword")
        
        currentUser = nil
        onCompletion(nil)
        defaults.synchronize()
        return
    }
}