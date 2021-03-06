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
    case open
    case abandoned
}
class OXGame{
    
    var board:[CellType]
    var startType:CellType
    
    var ID:Int
    var host:String
    
    init(ID:Int, host:String, boardString:String)  {
        
        startType=CellType.X
        self.ID = ID
        self.host = host
        self.board=[CellType](count:9,repeatedValue:CellType.Empty)
        
        //we are simulating setting our board from the internet
        
            //update this string to different values to test your model serialisation
        deserialiseBoard(boardString) //your OXGame board model should get set here
          
        
        /*if(simulatedBoardStringFromNetwork == serialiseBoard())    {
            print("start\n------------------------------------")
            print("congratulations, you successfully deserialised your board and serialized it again correctly. You can send your data model over the internet with this code. 1 step closer to network OX ;)")
            
            print("done\n------------------------------------")
        }   else    {
            print("start\n------------------------------------")
            print ("your board deserialisation and serialization was not correct :( carry on coding on those functions")
            
            print("done\n------------------------------------")
        }*/
        
    }
    func deserialiseBoard(boardString: String) {
        var cellList = [CellType]()
        for ch in boardString.characters{
            if ch == "o"{
                cellList.append(CellType.O)
        }
            else if ch == "x"{
                cellList.append(CellType.X)
            }
            else {
                cellList.append(CellType.Empty)
            }
        }
        
        board = cellList
    }
    func serialiseBoard()->String {
        var newString = ""
        for cell in board{
            if cell == CellType.Empty{
                newString = newString + "_"
            }
            else if cell == CellType.O{
                newString = newString + "o"
            }
            else if cell == CellType.X{
                newString = newString + "x"
            }
        }
        return newString
    }
    func turnCount()->Int{
        var turn = 0
        for cell in board{
            if cell == CellType.O || cell == CellType.X{
                turn += 1
            }
        }
        return turn
    }
    func whoJustPlayed() -> CellType{
        let turns = turnCount()
        if (turns%2 == 0 && turns != 0){
            return CellType.O
        }
        else {
            return CellType.X
        }

    }
    func whoseTurn() ->CellType{
        let turns = turnCount()
        if (turns%2 == 0 ){
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
        
        if (board[0]==board[3] && board[3]==board[6] && board[0] != CellType.Empty){
               return true
        }
        else if (board[1]==board[4] && board[4]==board[7] && board[1] != CellType.Empty){
                return true
        }
        else if (board[2]==board[5] && board[5]==board[8] && board[2] != CellType.Empty){
                return true
        }
        else if (board[0]==board[1] && board[1]==board[2] && board[0] != CellType.Empty){
                return true
        }
        else if (board[3]==board[4] && board[4]==board[5] && board[3] != CellType.Empty){
                return true
        }
        else if (board[6]==board[7] && board[7]==board[8] && board[6] != CellType.Empty){
                return true
        }
        else if (board[0]==board[4] && board[4]==board[8] && board[0] != CellType.Empty){
                return true
        }
        else if (board[2]==board[4] && board[4]==board[6] && board[2] != CellType.Empty){
                return true
        }
        else {
            return false
        }
            
    }
    func state()->OXGameState{
        if (turnCount() > 8){
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
    }
    
        
    
}

