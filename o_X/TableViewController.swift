//
//  TableViewController.swift
//  o_X
//
//  Created by David Xu on 7/4/16.
//  Copyright © 2016 iX. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    @IBAction func refreshButtonPressed(sender: UIBarButtonItem) {
        let request = OXGameController.sharedInstance.createMutableRequest(NSURL(string:"https://ox-backend.herokuapp.com/games"), method: "GET", parameters: nil)
        OXGameController.sharedInstance.executeRequest(request, requestCompletionFunction: {responseCode, json in
            
            if responseCode == 200{
                self.gameList = [OXGame]()
                for (_,game) in json{
                    //game = [string, json]
                    
                    let id = game["id"].intValue
                    let host = game["host_user"]["uid"].stringValue
                    let oxGame = OXGame(ID:id,host:host,boardString: "_________")
                    self.gameList.append(oxGame)
                    }
                
            }
            else {
                print("Not getting games")
            }
        })
    self.tableView.reloadData()
        
    }
    @IBAction func addButtonPressed(sender: UIBarButtonItem) {
        let request = OXGameController.sharedInstance.createMutableRequest(NSURL(string:"https://ox-backend.herokuapp.com/games/"), method: "POST", parameters: nil)
        OXGameController.sharedInstance.executeRequest(request, requestCompletionFunction: {responseCode, json in
            print(responseCode)
            print(json)
            if responseCode/100 == 2{
                self.boardString = json["board"].stringValue
                print(self.boardString)
                OXGameController.sharedInstance.setCurrentGame(json["id"].intValue, host: json["host_user"]["uid"].stringValue, boardString: json["board"].stringValue)
                self.performSegueWithIdentifier("newGame", sender: sender)
            }
            else {
                print("unable create a new game")
            }
        })
    }
    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)

    }
    var boardString:String?
    var gameList = [OXGame]()
    var gameID:Int?
    var host: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        OXGameController.sharedInstance.getGame(onCompletion: {gameList,message in
            if gameList != nil {
            self.gameList = gameList!
            self.tableView.reloadData()
            }
            else {
                print(message)
            }
        })

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func createList()->[String]{
        var stringList:[String] = []
        
        for game in gameList{
            let newString = "ID: \(game.ID), host: \(game.host)"
            stringList.append(newString)

        }
        return stringList
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return gameList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var stringList = createList()
        
        let cell = tableView.dequeueReusableCellWithIdentifier("new", forIndexPath: indexPath)
       
        // Configure the cell...
        cell.textLabel?.text = String(stringList[indexPath.row])

        return cell
    }
   override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let gameID = gameList[indexPath.row].ID
    let request = OXGameController.sharedInstance.createMutableRequest(NSURL(string:"https://ox-backend.herokuapp.com/games/\(gameID)/join"), method: "GET", parameters: nil)
    OXGameController.sharedInstance.executeRequest(request, requestCompletionFunction: {responseCode, json in
        if responseCode/100 == 2{
            OXGameController.sharedInstance.setCurrentGame(json["id"].intValue, host: json["host_user"]["uid"].stringValue, boardString: json["board"].stringValue)
            self.performSegueWithIdentifier("newGame", sender: self.tableView.cellForRowAtIndexPath(indexPath))
        }
        else{
            print("unable to join a game")
        }
    })
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newGame"{
            if let dvc = segue.destinationViewController as? BoardViewController{
                dvc.network_mode = true
                
                print(dvc.network_mode)
                            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
