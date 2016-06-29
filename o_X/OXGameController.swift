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
    private var currentGame:OXGame = OXGame()
    func getCurrentGame() -> OXGame {
        return currentGame
    }
    func restartGame() {
        currentGame = OXGame()
    }
    func playMove(boardInd:Int){
        currentGame.playMove(boardInd)
    }
}
