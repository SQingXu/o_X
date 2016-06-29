//
//  OXGame.swift
//  o_X
//
//  Created by David Xu on 6/29/16.
//  Copyright © 2016 iX. All rights reserved.
//

import Foundation

enum CellType : String{
    case O = "O"
    case X = "X"
    case Empty = ""
}
enum OXGameState {
    case InProgress
    case Tie
    case Won
}
class OXGame{
    var board:[CellType]
    var startType:CellType
    var turns:Int
    init(){
        startType=CellType.X
        board=[CellType](count:9,repeatedValue:CellType.Empty)
        turns=0
    }
    func turnCount()->Int{
        return turns
    }
    func whoseTurn() ->CellType{
        if (turns%2==0){
            return CellType.X
        }
        else {
            return CellType.O
        }
    }
    func playMove(onBoardInd:Int) -> CellType{
        board[onBoardInd] = whoseTurn()
        return whoseTurn()
    }
    func gameWon() ->Bool{
        
        if (board[0]==board[3] && board[3]==board[6]){
               return true
        }
        else if (board[1]==board[4] && board[4]==board[7]){
                return true
        }
        else if (board[2]==board[5] && board[5]==board[8]){
                return true
        }
        else if (board[0]==board[1] && board[1]==board[2]){
                return true
        }
        else if (board[3]==board[4] && board[4]==board[5]){
                return true
        }
        else if (board[6]==board[7] && board[7]==board[8]){
                return true
        }
        else if (board[0]==board[4] && board[4]==board[8]){
                return true
        }
        else if (board[2]==board[4] && board[4]==board[6]){
                return true
        }
        else {
            return false
        }
            
    }
    func state()->OXGameState{
        if (turnCount() >= 8){
            if (gameWon()==true){
                return OXGameState.Won
            }
            else{
                return OXGameState.Tie
            }
        }
        else{
            if (gameWon()==true){
                return OXGameState.Won
            }
            else{
                return OXGameState.InProgress
            }
        }
    }
    func reset(){
        board=[CellType](count:9,repeatedValue:CellType.Empty)
        turns=0
    }
    
        
    
}

