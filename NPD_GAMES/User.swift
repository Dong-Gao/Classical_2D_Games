//
//  User.swift
//  NPD_GAMES
//
//  Created by DongGao on 13/5/17.
//  Copyright © 2017 TheGreatMind. All rights reserved.

//  This class is used to define data stucts

import UIKit


// To store the information of user
struct User {
    var pid: Int
    var name: String
    var username: String
    var password: String
    var email: String
    var age: Int
    var pipeLevel: Int
    var ballLevel: Int
    var balloonLevel: Int
    var breakoutLevel: Int
    var cardLevel: Int
    var colorLevel: Int
    var gid: Int
    
    init(pid: Int, name: String, username: String, password: String, email: String, age: Int, pipeLevel: Int, ballLevel: Int, balloonLevel: Int, breakoutLevel: Int, cardLevel: Int, colorLevel: Int, gid: Int) {
        self.pid = pid
        self.name = name
        self.username = username
        self.password = password
        self.email = email
        self.age = age
        self.pipeLevel = pipeLevel
        self.ballLevel = ballLevel
        self.balloonLevel = balloonLevel
        self.breakoutLevel = breakoutLevel
        self.cardLevel = cardLevel
        self.colorLevel = colorLevel
        self.gid = gid
 
    }
    
    init() {
        self.pid = -1
        self.name = ""
        self.username = ""
        self.password = ""
        self.email = ""
        self.age = 0
        self.pipeLevel = 0
        self.ballLevel = 0
        self.balloonLevel = 0
        self.breakoutLevel = 0
        self.cardLevel = 0
        self.colorLevel = 0
        self.gid = 0

    }
}

// To store the information of game record
struct GameInfo {
    var pid: Int?
    var gid: Int?
    var time: String?
    var level: Int?
    var score: Int?
    var percentage: Int?
    
}

//  To store the information of game characters and levels
struct LevelInfo {
    var title:String
    var images:[String]
}

// To lock the screen for specific landscape or portrait
struct AppUtility {
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    
}











