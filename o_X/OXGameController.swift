//
//  OXGameController.swift
//  o_X
//
//  Created by David Xu on 6/29/16.
//  Copyright © 2016 iX. All rights reserved.
//

import Foundation
class OXGameController:WebService{
    static let sharedInstance = OXGameController()
    private override init(){
        
    }
    var numGame = 0
    private var currentGame = OXGame(ID: 0, host: "David",boardString:"_________")
    var gameList=[OXGame]()
    private var trackedBoard = [Int]()
    
    func getCurrentGame() -> OXGame {
        return currentGame
    }
    
    func setCurrentGame(ID: Int, host:String,boardString:String) {
        currentGame = OXGame(ID: ID, host: host, boardString: boardString)
    }
    
    func restartGame() {
        numGame+=1
        gameList.append(currentGame)
        currentGame = OXGame(ID: numGame, host: "David",boardString:"_________")
    }
    func playMove(boardInd:Int){
        currentGame.playMove(boardInd)
        for ind in 1...OXGameController.sharedInstance.currentGame.board.count{
            if OXGameController.sharedInstance.currentGame.board[ind-1] == CellType.Empty {
                trackedBoard.append(ind)
            }
        }

    }
   
        
    
    func playRandomMove()->Int{
        let randomNumber = Int(arc4random_uniform(UInt32(trackedBoard.count - 1)))
        OXGameController.sharedInstance.playMove(Int(trackedBoard[randomNumber]-1))
        let newNum = trackedBoard[randomNumber]
        trackedBoard=[Int]()
        return newNum
    }
    func getGame(onCompletion onCompletion:([OXGame]?,String?)->Void){
        var gameList = [OXGame]()
        let currentUser = UserController.sharedInstance.currentUser
        let user =  ["email":currentUser!.email,"password" : currentUser!.password]
        let request = createMutableRequest(NSURL(string:"https://ox-backend.herokuapp.com/games"), method: "GET", parameters: user)
        self.executeRequest(request, requestCompletionFunction: {responseCode,json in
            if responseCode == 200{
                for (_,game) in json{
                    //game = [string, json]
                    
                    let id = game["id"].intValue
                    let host = game["host_user"]["uid"].stringValue
                    let oxGame = OXGame(ID:id,host:host,boardString: "_________")
                    gameList.append(oxGame)
                    onCompletion(gameList,nil)
                }
                
            }
            else {
                onCompletion(nil,"Not getting games")
            }
        })
    }
}
