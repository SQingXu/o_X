//
//  UserController.swift
//  o_X
//
//  Created by David Xu on 6/30/16.
//  Copyright © 2016 iX. All rights reserved.
//

import Foundation
import Alamofire


class UserController:WebService {
    
    static var sharedInstance = UserController()
    private override init() {
        super.init()
    }
    
    var userList = [User]()
    var currentUser: User?
    let defaults = NSUserDefaults.standardUserDefaults()
    
    func register(email email: String, password: String, onCompletion: (User? ,String?) -> Void) {
        if (password.characters.count < 6){
            onCompletion(nil, "Passwords must be at least 6 characters long.")
            return
        }
        let user = ["email" : email, "password": password]
        
        let request = self.createMutableAnonRequest(NSURL(string: "https://ox-backend.herokuapp.com/auth"), method: "POST", parameters: user)
        self.executeRequest(request, requestCompletionFunction: {(responseCode, json) in
            print(json)
            print(responseCode)
            
            var user:User = User(email: email, password: password, client: "", token:"")
            user.email = email
            user.password = "not_saved"
            
            if (responseCode == 200) {
                user = User(email: json["data"]["email"].stringValue, password: "not_given_and_not_stored", client: json["data"]["client"].stringValue, token: json["data"]["token"].stringValue)
                self.currentUser = user
                onCompletion(user, nil)
                self.defaults.setObject(email, forKey: "CurrentUserEmail")
                self.defaults.setObject(password, forKey: "CurrentUserPassword")
                onCompletion(user, nil)
                self.defaults.synchronize()

                
            }
            else {
                let errorMessage = json["error"]["full_message"][0].stringValue
                onCompletion(nil,errorMessage)
            }
            
            
        })
        
        
        
    }
    
    func login(email email:String, password:String,onCompletion:(User?,String?) -> Void) {
        let user = ["email":email,"password" : password]
        let request = createMutableAnonRequest(NSURL(string: "https://ox-backend.herokuapp.com/auth/sign_in"), method: "POST", parameters: user)
        
        self.executeRequest(request, requestCompletionFunction: {responseCode,json in
            print(json)
            print(responseCode)
            
            var user = User(email: email, password: password, client: "", token: "")
            user.email = email
            user.password = "not_saved"
            
            if (responseCode == 200){
                user = User(email: json["data"]["email"].stringValue, password: "not_stored_not_saved", client: json["data"]["client"].stringValue, token: json["data"]["token"].stringValue)
                self.currentUser = user
                
                self.defaults.setObject(email, forKey: "CurrentUserEmail")
                self.defaults.setObject(password, forKey: "CurrentUserPassword")
                
                onCompletion(user, "Log in succeed")
                self.defaults.synchronize()
                return
            }
            else{
                onCompletion(nil, "Your username or password is incorrect")
                return
            }
            
        })
        
        
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