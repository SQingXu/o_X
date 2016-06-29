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
    func restartGame(){
        for elements in boardView.subviews{
            if let button = elements as? UIButton{
                button.setTitle("", forState: UIControlState.Normal)
               button.enabled=true
            }
        }
        OXGameController.sharedInstance.restartGame()
    }
    
    //create a new instance of a Game object
    
    @IBAction func newGameButtonPressed(sender: UIButton) {
        restartGame()
    }
    
    @IBAction func positionButtonPressed(sender: UIButton) {
        OXGameController.sharedInstance.playMove(sender.tag)
        sender.enabled=false
        let whoseTurn:String=OXGameController.sharedInstance.getCurrentGame().whoseTurn().rawValue
        sender.setTitle(whoseTurn, forState: UIControlState.Normal)
        if (OXGameController.sharedInstance.getCurrentGame().state()==OXGameState.Tie){
            print("The Game is Tied")
            restartGame()
        }
        else if(OXGameController.sharedInstance.getCurrentGame().state()==OXGameState.Won){
            let winnerName=OXGameController.sharedInstance.getCurrentGame().whoseTurn().rawValue
            print("The Player \(winnerName) won")
            restartGame()
        }
        else{
            
        }
 
     
    }
    
    @IBAction func logOutPressed(sender: UIButton) {
        print("Logout Pressed")
    }
    
}
