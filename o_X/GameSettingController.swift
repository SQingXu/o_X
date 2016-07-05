//
//  GameSettingController.swift
//  o_X
//
//  Created by David Xu on 7/1/16.
//  Copyright © 2016 iX. All rights reserved.
//

import Foundation
class GameSettingController{
    static var sharedInstance = GameSettingController()
    private init(){ }
    
    var currentSettings = GameSettings()
    
    func gameModeChange() {
        if currentSettings.gameModeSwitch == true{
            currentSettings.gameModeSwitch = false
        }
        else {
            currentSettings.gameModeSwitch = true
        }
    }

    
}