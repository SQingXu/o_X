//
//  OXGameController.swift
//  o_X
//
//  Created by David Xu on 6/29/16.
//  Copyright © 2016 iX. All rights reserved.
//

import Foundation
class OXGameController{
    static let sharedInstance = OXGameController()
    private init(){
        
    }
    var numGame = 0
    private var currentGame = OXGame(ID: 0, host: "David")
    var gameList=[OXGame]()
    private var trackedBoard = [Int]()
    
    func getCurrentGame() -> OXGame {
        return currentGame
    }
    
    func restartGame() {
        numGame+=1
        gameList.append(currentGame)
        currentGame = OXGame(ID: numGame,host: "David")
        
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
        onCompletion(gameList,nil)
    }
}
