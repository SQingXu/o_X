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
        newGameButton.hidden=true
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func restartGame(){
        for element in boardView.subviews {
            if let button = element as? UIButton {
                button.setTitle("", forState: UIControlState.Normal)
                button.enabled=true
            }
        }
        OXGameController.sharedInstance.restartGame()
    }
    
    //create a new instance of a Game object
    
    @IBAction func newGameButtonPressed(sender: UIButton) {
        restartGame()
        newGameButton.hidden=true
    }
    
    @IBAction func positionButtonPressed(sender: UIButton) {
        OXGameController.sharedInstance.playMove(sender.tag)
        
        //made the button unclickable
        sender.enabled=false
        
        let whoseTurn:String=OXGameController.sharedInstance.getCurrentGame().whoseTurn().rawValue
        sender.setTitle(whoseTurn, forState: UIControlState.Normal)
        
        //check game state
        if (OXGameController.sharedInstance.getCurrentGame().state()==OXGameState.Tie){
            print("The Game is Tied")
            let alert = UIAlertController(title: "Game Over", message: "The Game Tied", preferredStyle: UIAlertControllerStyle.Alert)
            let aletAction2 = UIAlertAction(title: "Dismiss", style: .Cancel, handler: {(action) in
                self.newGameButton.hidden=false
            })
            alert.addAction(aletAction2)
            self.presentViewController(alert, animated: true, completion: nil)
            for element in boardView.subviews {
                if let button = element as? UIButton {
                    button.enabled=false
                }
            }

            
        }
        else if(OXGameController.sharedInstance.getCurrentGame().state()==OXGameState.Won){
            let winnerName=OXGameController.sharedInstance.getCurrentGame().whoseTurn().rawValue
            let alert = UIAlertController(title: "Game Over", message: "The Player \(winnerName) won", preferredStyle: UIAlertControllerStyle.Alert)
            let aletAction2 = UIAlertAction(title: "Dismiss", style: .Cancel, handler: {(action) in
                self.newGameButton.hidden=false
            })
            alert.addAction(aletAction2)
             self.presentViewController(alert, animated: true, completion: nil)
            for element in boardView.subviews {
                if let button = element as? UIButton {
                    button.enabled=false
                }
            }
        }
        else{
            
        }
 
     
    }
    
    
    @IBAction func switchChanged(sender: UISwitch) {
        print("Switch")
    }
    @IBAction func logOutPressed(sender: UIButton) {

        UserController.sharedInstance.logout(onCompletion: { message in
            if message == nil {
                // logout good
                let controller = UIStoryboard(name: "Onboarding", bundle: nil).instantiateInitialViewController()
                UIApplication.sharedApplication().keyWindow?.rootViewController = controller
            } else {
                
                // logout bad
                let alert = UIAlertController(title: "Logout Failed", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                let alertAction = UIAlertAction(title: "Back To Game", style: .Cancel, handler: nil)
                alert.addAction(alertAction)
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
        })
    }
    
}
