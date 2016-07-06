//
//  BoardViewController.swift
//  o_X
//

import UIKit


class BoardViewController: UIViewController {

        // Create additional IBOutlets here.
    
    @IBOutlet weak var boardView: UIView!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBAction func cancelGame(sender: UIBarButtonItem) {
        print(OXGameController.sharedInstance.getCurrentGame().ID)
        let request = OXGameController.sharedInstance.createMutableRequest(NSURL(string:"https://ox-backend.herokuapp.com/games/\(OXGameController.sharedInstance.getCurrentGame().ID)"), method: "DELETE", parameters: nil)
        OXGameController.sharedInstance.executeRequest(request, requestCompletionFunction: {responseCode, json in
            if responseCode/100 == 2{
                self.navigationController?.popViewControllerAnimated(true)
                self.network_mode = false
            
            }
            else {
                print(responseCode)
                self.navigationController?.popViewControllerAnimated(true)
                print("error in exit game")
            }
        })
    }
    
    @IBOutlet weak var newGameButton: UIButton!
    var network_mode:Bool = false
    var userIdentity = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
            newGameButton?.hidden=true
            updateUI()
            getGame()
        if network_mode{
            if UserController.sharedInstance.currentUser?.email != OXGameController.sharedInstance.getCurrentGame().host {
                userIdentity = "guest"
            }
            else {
                userIdentity = "host"
            }
        }
        
        print(OXGameController.sharedInstance.getCurrentGame().ID)
        
            // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        
    }
    func restartGame(){
        for element in self.boardView.subviews {
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
        newGameButton?.hidden=true
    }
    
    @IBAction func positionButtonPressed(sender: UIButton) {
        if GameSettingController.sharedInstance.currentSettings.gameModeSwitch == true{
            if network_mode == false{
            OXGameController.sharedInstance.playMove(sender.tag-1)
            let whoseTurn:String=OXGameController.sharedInstance.getCurrentGame().whoJustPlayed().rawValue
            sender.enabled=false
            print(OXGameController.sharedInstance.getCurrentGame().ID)
            sender.setTitle(whoseTurn, forState: UIControlState.Normal)
            checkstate()
            }
            else {
                let previous = OXGameController.sharedInstance.getCurrentGame().serialiseBoard()
                OXGameController.sharedInstance.playMove(sender.tag-1)
                let whoseTurn:String=OXGameController.sharedInstance.getCurrentGame().whoJustPlayed().rawValue
                let request = OXGameController.sharedInstance.createMutableRequest(NSURL(string:"https://ox-backend.herokuapp.com/games/\(OXGameController.sharedInstance.getCurrentGame().ID)"), method: "PUT", parameters: ["board":OXGameController.sharedInstance.getCurrentGame().serialiseBoard()])
                
                OXGameController.sharedInstance.executeRequest(request, requestCompletionFunction: {responseCode, json in
                    
                    if responseCode/100==2{
                        sender.enabled=false
                        sender.setTitle(whoseTurn, forState: UIControlState.Normal)
                    }
                    else{
                        let alert = UIAlertController(title: "Wrong Move!", message: "It is not your turn yet", preferredStyle: UIAlertControllerStyle.Alert)
                        let aletAction2 = UIAlertAction(title: "Dismiss", style: .Cancel, handler: {(action) in  })
                        alert.addAction(aletAction2)
                        self.presentViewController(alert, animated: true, completion: nil)
                        OXGameController.sharedInstance.getCurrentGame().deserialiseBoard(previous)
                    }
                    
                    
                })

            }
            
        }
        else {
            OXGameController.sharedInstance.playMove(sender.tag-1)
            sender.enabled=false
            
            let whoseTurn:String=OXGameController.sharedInstance.getCurrentGame().whoseTurn().rawValue
            sender.setTitle(whoseTurn, forState: UIControlState.Normal)
            
            
            if (OXGameController.sharedInstance.getCurrentGame().state()==OXGameState.Tie || OXGameController.sharedInstance.getCurrentGame().state()==OXGameState.Won){
            }
            else{
                let tagNum = OXGameController.sharedInstance.playRandomMove()
                let otherButton = self.boardView.viewWithTag(tagNum) as! UIButton
                otherButton.setTitle(OXGameController.sharedInstance.getCurrentGame().whoseTurn().rawValue, forState: UIControlState.Normal)
                otherButton.enabled = false

            }
        }
    }
        
        //made the button unclickable
        
        
        //check game state
    func checkstate(){
       if (OXGameController.sharedInstance.getCurrentGame().state()==OXGameState.Tie){
            print("The Game is Tied")
            let alert = UIAlertController(title: "Game Over", message: "The Game Tied", preferredStyle: UIAlertControllerStyle.Alert)
            let aletAction2 = UIAlertAction(title: "Dismiss", style: .Cancel, handler: {(action) in
                self.newGameButton?.hidden=false
            })
            alert.addAction(aletAction2)
            self.presentViewController(alert, animated: true, completion: nil)
            for element in boardView.subviews {
                if let button = element as? UIButton {
                    button.enabled=false
                }
            }

            
        }
        else if (OXGameController.sharedInstance.getCurrentGame().state()==OXGameState.Won){
            let winnerName=OXGameController.sharedInstance.getCurrentGame().whoJustPlayed().rawValue
            let alert = UIAlertController(title: "Game Over", message: "The Player \(winnerName) won", preferredStyle: UIAlertControllerStyle.Alert)
            let aletAction2 = UIAlertAction(title: "Dismiss", style: .Cancel, handler: {(action) in
                self.newGameButton?.hidden=false
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
    func updateUI(){
        for element in 1...9{
            let button = self.view.viewWithTag(element) as? UIButton
            button?.setTitle(OXGameController.sharedInstance.getCurrentGame().board[element - 1].rawValue, forState: UIControlState.Normal)
        }
    
    }
    
    func getGame(){
        let request = OXGameController.sharedInstance.createMutableRequest(NSURL(string:"https://ox-backend.herokuapp.com/games/\(OXGameController.sharedInstance.getCurrentGame().ID)"), method: "GET", parameters: nil)
        OXGameController.sharedInstance.executeRequest(request, requestCompletionFunction: {responseCode,json in
            if responseCode/100 == 2{
                if OXGameController.sharedInstance.getCurrentGame().serialiseBoard() != json["board"].stringValue{
                     OXGameController.sharedInstance.getCurrentGame().deserialiseBoard(json["board"].stringValue)
                    self.checkstate()
                }
            else {OXGameController.sharedInstance.getCurrentGame().deserialiseBoard(json["board"].stringValue)
                }
            if json["state"].stringValue=="in_progress"{
                if self.userIdentity == "host"{
                    if OXGameController.sharedInstance.getCurrentGame().whoseTurn().rawValue == "X"{
                         self.statusLabel.text = "Yours turn!"                }
                    else{
                         self.statusLabel.text = "Waiting for opponent's move..."
                    }
                }
                else if self.userIdentity == "guest"{
                    if OXGameController.sharedInstance.getCurrentGame().whoseTurn().rawValue == "O"{
                        self.statusLabel.text = "Yours turn!"                }
                    else{
                        self.statusLabel.text = "Waiting for opponent's move..."
                    }
                }
                
                }
            else if json["state"].stringValue == "open"{
                self.statusLabel.text = "waiting for the other opponent"
                }
            else if json["state"].stringValue == "abandoned"{
                self.statusLabel.text = "The player has just left"
                }
            
                
                self.updateUI()
                self.getGame()
            }
            else{
                print("get game error")
            }
        })

    }
    
    
}
