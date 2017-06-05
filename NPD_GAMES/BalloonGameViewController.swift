//
//  BalloonGameViewController.swift
//  NPD_GAMES
//
//  Created by DongGao on 17/4/17.
//  Copyright © 2017 TheGreatMind. All rights reserved.
//

import UIKit
import SpriteKit

class BalloonGameViewController: UIViewController {
    
    @IBOutlet weak var quitBtn: UIButton!
    @IBOutlet weak var retryBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    
    
    var currentLevel: Int = 0
    let scene = BalloonGameScene(fileNamed: "BalloonGameScene")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retryBtn.tag = 1
        nextBtn.tag = 2
        quitBtn.tag = 3
        switch currentLevel {
        case 1:
            scene.startLevel1()
        case 2:
            scene.startLevel2()
        case 3:
            scene.startLevel3()
        case 4:
            scene.startLevel4()
        case 5:
            scene.startLevel5()
        case 6:
            scene.startLevel6()
        default:
            break
            
        }

        

    }
    
    
    override func viewDidAppear(_ animated: Bool) {

        // Configure the view.
        let view = self.view as! SKView
        view.showsFPS = true
        view.showsNodeCount = true
        
        // Sprite Kit applies additional optimizations to improve rendering performance
        view.ignoresSiblingOrder = true
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .resizeFill
        scene.size = view.bounds.size
        currentLevel = scene.currentlevel
        scene.viewController = self
        view.presentScene(scene)
        dismissButtons()


    }
    
    func dismissButtons() {
        retryBtn.isHidden = true
        nextBtn.isHidden = true
        quitBtn.isHidden = true
    }
    
    
    func saveGameRecord() {
        var gameInfo = GameInfo()
        gameInfo.pid = gameUser.pid
        gameInfo.gid = 3
        gameInfo.level = currentLevel
        gameInfo.time = ""
        gameInfo.score = 0
        gameInfo.percentage = 0
    }

    

    
    
    @IBAction func performBalloonRetry(_ sender: AnyObject) {
        switch currentLevel {
        case 1:
            scene.startLevel1()
        case 2:
            scene.startLevel2()
        case 3:
            scene.startLevel3()
        case 4:
            scene.startLevel4()
        case 5:
            scene.startLevel5()
        case 6:
            scene.startLevel6()
        default:
            break
        }

        
        dismissButtons()
    }
    
    @IBAction func performBalloonNextLevel(_ sender: AnyObject) {
        
        switch currentLevel {
        case 1:
            scene.startLevel2()
        case 2:
            scene.startLevel3()
        case 3:
            scene.startLevel4()
        case 4:
            scene.startLevel5()
        case 5:
            scene.startLevel6()
        default:
            break
        }
        
        dismissButtons()
    }
    
    @IBAction func performBalloonQuit(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
