//
//  BreakOutViewController.swift
//  NPD_GAMES
//
//  Created by DongGao on 12/5/17.
//  Copyright © 2017 TheGreatMind. All rights reserved.
//

import UIKit
import SpriteKit

class BreakOutViewController: UIViewController {
    
    @IBOutlet weak var breakBg: UIImageView!
    @IBOutlet weak var retryBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var quitBtn: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var highestLabel: UILabel!
    @IBOutlet weak var liveLabel: UILabel!
    
    let scene = BreakOutScene(fileNamed: "BreakOutScene")!
    var currentLevel: Int = 1
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Reset when view is being removed
        AppUtility.lockOrientation(.all)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        retryBtn.tag = 1
        nextBtn.tag = 2
        quitBtn.tag = 3
        scoreLabel.tag = 4
        nextLabel.tag = 5
        levelLabel.tag = 6
        highestLabel.tag = 7
        liveLabel.tag = 8
        

        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        AppUtility.lockOrientation(.landscape)
        
        //let scene = BreakOutScene(fileNamed: "BreakOutScene")!
        scene.currentLevel = currentLevel
        
        if let view = self.view as! SKView? {
            // Configure the view.
            let skView = SKView(frame: CGRect(x: 0, y: 0, width: view.frame.width - breakBg.frame.width, height: view.frame.height))
            

            self.view.addSubview(skView)
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = SKSceneScaleMode.fill
            skView.presentScene(scene)

        }

            // set three buttons
            self.view.bringSubview(toFront: retryBtn)
            self.view.bringSubview(toFront: nextBtn)
            self.view.bringSubview(toFront: quitBtn)
            dismissButtons()
        
        
        // Do any additional setup after loading the view.
    }

    
    
    
    @IBAction func performRetry(_ sender: AnyObject) {
        
        switch (scene.currentLevel) {
        case 1:
            scene.startLevel1()
        case 2:
            scene.startLevel2()
        default:
            break
        }
        
        dismissButtons()
    }
    
    @IBAction func performNextLevel(_ sender: AnyObject) {
        if currentLevel == 1 {
            currentLevel += 1
        }
        
        scene.setLifeLeft(scene.getLifeLeft() - 1)
        if (scene.getCurrentLevel() == 1) {
            scene.setLifeLeft(1)
            scene.startLevel2()
        }
        
        dismissButtons()
    }
    
    @IBAction func performQuit(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissButtons() {
        retryBtn.isHidden = true
        nextBtn.isHidden = true
        quitBtn.isHidden = true
    }
    
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    //Only support landscape orientation
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations:UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }


}
