//
//  LoginViewController.swift
//  o_X
//
//  Created by David Xu on 6/30/16.
//  Copyright © 2016 iX. All rights reserved.
//

import UIKit
import Alamofire


class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        emailField.becomeFirstResponder()
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailField{
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField{
            passwordField.resignFirstResponder()
        }
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        UserController.sharedInstance.login(email: emailField.text!, password: passwordField.text!, onCompletion: { user, message in
                if user != nil {
                    // switch to main storyboard
                    let controller = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                    UIApplication.sharedApplication().keyWindow?.rootViewController = controller
                    OXGameController.sharedInstance.restartGame()
                    
                } else {
                    // show alertview
                    let alert = UIAlertController(title: "Login Failed", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    let alertAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
                    alert.addAction(alertAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })

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
