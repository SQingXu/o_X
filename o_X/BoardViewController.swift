//
//  BoardViewController.swift
//  o_X
//

import UIKit


class BoardViewController: UIViewController {

        // Create additional IBOutlets here.
    
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var newGameButton: UIButton!

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //create a new instance of a Game object
    var gameObject = OXGame()
    
    @IBAction func newGameButtonPressed(sender: UIButton) {
        print("New Game")
    }
    
    @IBAction func positionButtonPressed(sender: UIButton) {
        print(sender.tag)
     
    }
    
    @IBAction func logOutPressed(sender: UIButton) {
        print("Logout Pressed")
    }
    
}
