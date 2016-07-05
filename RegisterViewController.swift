//
//  RegisterViewController.swift
//  o_X
//
//  Created by David Xu on 6/30/16.
//  Copyright © 2016 iX. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    
    @IBAction func registerButtonPressed(sender: UIButton) {
        UserController.sharedInstance
            .register(email: emailText.text!, password: passwordText.text!, onCompletion: { user, message in
            if user != nil {
                // switch to main storyboard
                let controller = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                UIApplication.sharedApplication().keyWindow?.rootViewController = controller
                OXGameController.sharedInstance.restartGame()
            } else {
                // show alertview
                let alert = UIAlertController(title: "Register Failed", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                let alertAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
                alert.addAction(alertAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailText.delegate = self
        passwordText.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        emailText.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailText {
            passwordText.becomeFirstResponder()
        } else if textField == passwordText {
            passwordText.resignFirstResponder()
        }
        
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
