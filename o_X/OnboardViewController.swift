//
//  OnboardViewController.swift
//  o_X
//
//  Created by David Xu on 7/2/16.
//  Copyright © 2016 iX. All rights reserved.
//

import UIKit

class OnboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true

        // Do any additional setup after loading the view.
    }
    @IBAction func dButtonPressed(sender: UIButton) {
        if sender.currentTitle == "X" {
            sender.setTitle("O", forState: UIControlState.Normal)
        }
        else{
            sender.setTitle("X", forState: UIControlState.Normal)
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
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
