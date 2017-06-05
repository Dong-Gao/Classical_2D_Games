//
//  NotificationViewController.swift
//  NPD_GAMES
//
//  Created by DongGao on 15/5/17.
//  Copyright © 2017 TheGreatMind. All rights reserved.

//  This class is used to show the game result and perform a segue to next step

import UIKit

class NotificationViewController: UIViewController {
    

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var retryBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var quitBtn: UIButton!
    
    
    func showPipeGameNextLevel() {
        messageLabel.text = "Going on to next level!"
        
        resetBtn.isHidden = true
        retryBtn.isHidden = true
        
        nextBtn.tag = 1
        nextBtn.addTarget(self, action: #selector(NotificationViewController.performSegue(_:)), for: UIControlEvents.touchUpInside)
        
        quitBtn.tag = 2
        quitBtn.addTarget(self, action: #selector(NotificationViewController.performSegue(_:)), for: UIControlEvents.touchUpInside)
    }
    
    
    func showPipeGameWin() {
        messageLabel.text = "Congratulations!\nYou have won the game!"
        
        resetBtn.isHidden = true
        retryBtn.isHidden = true
        nextBtn.isHidden = true
        
        quitBtn.tag = 2
        quitBtn.addTarget(self, action: #selector(NotificationViewController.performSegue(_:)), for: UIControlEvents.touchUpInside)
    }
    
    
    func showPipeGameOver() {
        messageLabel.text = "Game Over!"
        
        resetBtn.isHidden = true
        retryBtn.isHidden = true
        nextBtn.isHidden = true
        
        quitBtn.tag = 2
        quitBtn.addTarget(self, action: #selector(NotificationViewController.performSegue(_:)), for: UIControlEvents.touchUpInside)
    }

    
    
    func showCardGameReset() {
        messageLabel.text = "Reset the game."
        
        resetBtn.tag = 5
        resetBtn.addTarget(self, action: #selector(NotificationViewController.performSegue(_:)), for: UIControlEvents.touchUpInside)
        
        retryBtn.isHidden = true
        nextBtn.isHidden = true
        
        quitBtn.tag = 7
        quitBtn.addTarget(self, action: #selector(NotificationViewController.performSegue(_:)), for: UIControlEvents.touchUpInside)
    }
    
    
    func showCardGameNextLevel() {
        messageLabel.text = "Next level."
        
        resetBtn.isHidden = true
        retryBtn.isHidden = true
        
        nextBtn.tag = 6
        nextBtn.addTarget(self, action: #selector(NotificationViewController.performSegue(_:)), for: UIControlEvents.touchUpInside)
        
        quitBtn.tag = 7
        quitBtn.addTarget(self, action: #selector(NotificationViewController.performSegue(_:)), for: UIControlEvents.touchUpInside)
    }
    
    
    func showCardGameWin() {
        messageLabel.text = "Congratulations!\nYou have won the game!"
        
        resetBtn.isHidden = true
        retryBtn.isHidden = true
        nextBtn.isHidden = true
        
        quitBtn.tag = 7
        quitBtn.addTarget(self, action: #selector(NotificationViewController.performSegue(_:)), for: UIControlEvents.touchUpInside)
    }
    
    
    func showColorGameOver(_ score: Int) {
        let score = score
        messageLabel.text = "Congratulations!\nYour score is \(score)"
        
        resetBtn.isHidden = true
        retryBtn.isHidden = true
        nextBtn.isHidden = true
        
        quitBtn.tag = 8
        quitBtn.addTarget(self, action: #selector(NotificationViewController.performSegue(_:)), for: UIControlEvents.touchUpInside)
    }


    func showDriftGameOver(_ score: Float) {
        let score = score
        messageLabel.text = "Fail!\nYour score is \(score) seconds"
        
        resetBtn.tag = 9
        resetBtn.addTarget(self, action: #selector(NotificationViewController.performSegue(_:)), for: UIControlEvents.touchUpInside)
        
        retryBtn.tag = 10
        retryBtn.addTarget(self, action: #selector(NotificationViewController.performSegue(_:)), for: UIControlEvents.touchUpInside)
        
        nextBtn.isHidden = true
        
        quitBtn.tag = 12
        quitBtn.addTarget(self, action: #selector(NotificationViewController.performSegue(_:)), for: UIControlEvents.touchUpInside)
    }
    
    
    func showDriftGameNextLevel(_ score: Float) {
        let score = score
        messageLabel.text = "Congratulations!\nYour score is \(score) seconds"
        
        resetBtn.tag = 9
        resetBtn.addTarget(self, action: #selector(NotificationViewController.performSegue(_:)), for: UIControlEvents.touchUpInside)
        
        retryBtn.tag = 10
        retryBtn.addTarget(self, action: #selector(NotificationViewController.performSegue(_:)), for: UIControlEvents.touchUpInside)
        
        nextBtn.tag = 11
        nextBtn.addTarget(self, action: #selector(NotificationViewController.performSegue(_:)), for: UIControlEvents.touchUpInside)
        
        quitBtn.tag = 12
        quitBtn.addTarget(self, action: #selector(NotificationViewController.performSegue(_:)), for: UIControlEvents.touchUpInside)
    }
    
    
    func showDriftGameWin() {
        messageLabel.text = "Congratulations!\nYou have won!"
        
        resetBtn.isHidden = true
        retryBtn.isHidden = true
        nextBtn.isHidden = true
        
        quitBtn.tag = 12
        quitBtn.addTarget(self, action: #selector(NotificationViewController.performSegue(_:)), for: UIControlEvents.touchUpInside)
    }

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        messageLabel.numberOfLines = 0

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func performSegue(_ sender: UIButton) {
        switch sender.tag {
        case 1:     // pipe game next level
            self.performSegue(withIdentifier: "unwindPipeGameNextLevel", sender: sender)
        case 2:     // pipe game quit
            self.performSegue(withIdentifier: "unwindPipeGameQuit", sender: sender)
        case 5:     // card game reset
            self.performSegue(withIdentifier: "unwindCardGameReset", sender: sender)
        case 6:     // card game next level
            self.performSegue(withIdentifier: "unwindCardGameNextLevel", sender: sender)
        case 7:     // card game quit
            self.performSegue(withIdentifier: "unwindCardGameQuit", sender: sender)
        case 8:
            self.performSegue(withIdentifier: "unwindColorGameQuit", sender: sender)
        case 9:     // drift game reset
            self.performSegue(withIdentifier: "unwindDriftGameReset", sender: sender)
        case 10:    // drift game retry
            self.performSegue(withIdentifier: "unwindDriftGameRetry", sender: sender)
        case 11:    // drift game next level
            self.performSegue(withIdentifier: "unwindDriftGameNextLevel", sender: sender)
        case 12:    // drift game quit
            self.performSegue(withIdentifier: "unwindDriftGameQuit", sender: sender)
        default:
            break
        }
    }

    //Only support portrait orientation
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations:UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

}
