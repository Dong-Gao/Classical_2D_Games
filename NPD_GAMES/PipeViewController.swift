//
//  PipeViewController.swift
//  NPD_GAMES
//
//  Created by DongGao on 12/5/17.
//  Copyright © 2017 TheGreatMind. All rights reserved.
//

import UIKit

class PipeViewController: UIViewController {
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var player: UIImageView!
    @IBOutlet weak var time: UILabel!
    
    let images =  ["animal1", "animal2","animal3", "animal4", "animal5","animal6","animal7","animal8","animal9","animal10"]
    var pipe_level1: CGMutablePath = CGMutablePath()
    var pipe_level2: CGMutablePath = CGMutablePath()
    var pipe_level3: CGMutablePath = CGMutablePath()
    var validTouch: Bool = false  // used for identifing whether pressed position is valid
    var startPoistion: CGPoint?
    var startFrame: CGRect?
    var startTime = TimeInterval()    // recording start time
    var timeCost: Int = 0                // how much time spent
    var timer = Timer()           // used for time counting
    var currentLevel = 1
    var gameCharacter = 0
    var currentPath: CGMutablePath?
    var gameScore: Int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        player.image = UIImage(named: images[gameCharacter])
        initPath()
        startGame(currentLevel)
    }

    func initPath() {
        let size = self.view.bounds.size
        let ratio_x = size.width / 640
        let ratio_y = size.height / 975
        
        // initialize the level 1 path
        pipe_level1.move(to: CGPoint(x: 639 * ratio_x, y: 860 * ratio_y))
        pipe_level1.addLine(to: CGPoint(x: 116 * ratio_x, y: 853 * ratio_y))
        pipe_level1.addLine(to: CGPoint(x: 105 * ratio_x, y: 817 * ratio_y))
        pipe_level1.addLine(to: CGPoint(x: 105 * ratio_x, y: 328 * ratio_y))
        pipe_level1.addLine(to: CGPoint(x: 210 * ratio_x, y: 328 * ratio_y))
        pipe_level1.addLine(to: CGPoint(x: 210 * ratio_x, y: 751 * ratio_y))
        pipe_level1.addLine(to: CGPoint(x: 639 * ratio_x, y: 751 * ratio_y))
        pipe_level1.closeSubpath()
        
        // initialize the leve 2 path
        pipe_level2.move(to: CGPoint(x: 0, y: 750 * ratio_y))
        pipe_level2.addLine(to: CGPoint(x: 208 * ratio_x, y: 750 * ratio_y))
        pipe_level2.addLine(to: CGPoint(x: 208 * ratio_x, y: 435 * ratio_y))
        pipe_level2.addLine(to: CGPoint(x: 540 * ratio_x, y: 433 * ratio_y))
        pipe_level2.addLine(to: CGPoint(x: 546 * ratio_x, y: 527 * ratio_y))
        pipe_level2.addLine(to: CGPoint(x: 639 * ratio_x, y: 537 * ratio_y))
        pipe_level2.addLine(to: CGPoint(x: 639 * ratio_x, y: 647 * ratio_y))
        pipe_level2.addLine(to: CGPoint(x: 426 * ratio_x, y: 645 * ratio_y))
        pipe_level2.addLine(to: CGPoint(x: 420 * ratio_x, y: 543 * ratio_y))
        pipe_level2.addLine(to: CGPoint(x: 322 * ratio_x, y: 539 * ratio_y))
        pipe_level2.addLine(to: CGPoint(x: 322 * ratio_x, y: 852 * ratio_y))
        pipe_level2.addLine(to: CGPoint(x: 0, y: 852 * ratio_y))
        pipe_level2.closeSubpath()
        
        // initialize the level 3 path
        pipe_level3.move(to: CGPoint(x: 0, y: 427 * ratio_y))
        pipe_level3.addLine(to: CGPoint(x: 204 * ratio_x, y: 429 * ratio_y))
        pipe_level3.addLine(to: CGPoint(x: 204 * ratio_x, y: 641 * ratio_y))
        pipe_level3.addLine(to: CGPoint(x: 320 * ratio_x, y: 643 * ratio_y))
        pipe_level3.addLine(to: CGPoint(x: 322 * ratio_x, y: 747 * ratio_y))
        pipe_level3.addLine(to: CGPoint(x: 422 * ratio_x, y: 747 * ratio_y))
        pipe_level3.addLine(to: CGPoint(x: 424 * ratio_x, y: 643 * ratio_y))
        pipe_level3.addLine(to: CGPoint(x: 526 * ratio_x, y: 633 * ratio_y))
        pipe_level3.addLine(to: CGPoint(x: 526 * ratio_x, y: 549 * ratio_y))
        pipe_level3.addLine(to: CGPoint(x: 312 * ratio_x, y: 537 * ratio_y))
        pipe_level3.addLine(to: CGPoint(x: 310 * ratio_x, y: 333 * ratio_y))
        pipe_level3.addLine(to: CGPoint(x: 426 * ratio_x, y: 333 * ratio_y))
        pipe_level3.addLine(to: CGPoint(x: 424 * ratio_x, y: 431 * ratio_y))
        pipe_level3.addLine(to: CGPoint(x: 632 * ratio_x, y: 429 * ratio_y))
        pipe_level3.addLine(to: CGPoint(x: 632 * ratio_x, y: 751 * ratio_y))
        pipe_level3.addLine(to: CGPoint(x: 540 * ratio_x, y: 751 * ratio_y))
        pipe_level3.addLine(to: CGPoint(x: 540 * ratio_x, y: 859 * ratio_y))
        pipe_level3.addLine(to: CGPoint(x: 206 * ratio_x, y: 859 * ratio_y))
        pipe_level3.addLine(to: CGPoint(x: 206 * ratio_x, y: 753 * ratio_y))
        pipe_level3.addLine(to: CGPoint(x: 100 * ratio_x, y: 749 * ratio_y))
        pipe_level3.addLine(to: CGPoint(x: 96  * ratio_x, y: 541 * ratio_y))
        pipe_level3.addLine(to: CGPoint(x: 0   * ratio_x, y: 541 * ratio_y))
        pipe_level3.closeSubpath()

        
    }
    
    func startGame(_ level: Int) {
        currentLevel = level
        let size = self.view.bounds.size
        let ratio_x = size.width / 640
        let ratio_y = size.height / 975
        var frame = player.frame
        
        
        switch (level) {
        case 1:
            currentPath = pipe_level1
            frame.origin.x = 114 * ratio_x
            frame.origin.y = 339 * ratio_y
            player.frame = frame
            bgImage.image = UIImage(named: "p_level1")
            
        case 2:
            currentPath = pipe_level2
            frame.origin.x = 12 * ratio_x
            frame.origin.y = 773 * ratio_y
            player.frame = frame
            bgImage.image = UIImage(named: "p_level2")
            
        case 3:
            currentPath = pipe_level3
            frame.origin.x = 12 * ratio_x
            frame.origin.y = 445 * ratio_y
            player.frame = frame
            
            bgImage.image = UIImage(named: "p_level3")
            
        default:
            currentPath = nil
        }
        
        time.text = "Time: 00:00"
        startTimer()

        
    }
    
    func startTimer() {
        startTime = Date.timeIntervalSinceReferenceDate
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(PipeViewController.updateTime), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func updateTime() {
        timeCost = Int(Date.timeIntervalSinceReferenceDate - startTime)
        
        let seconds = timeCost % 60
        let minutes = timeCost / 60
        
        time.text = String(format: "Time: %02d:%02d", minutes, seconds)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        
        startPoistion = touch.location(in: self.view)   // record start touched point
        startFrame = player.frame                // record position of the icon
        
        // validate whether the touched point is within the frame of the icon, if yes, set touch to be valid, otherwise invalid
        let playerFrame = self.view.convert(player.frame, from: player.superview)
        
        
        if playerFrame.contains(startPoistion!) {
            self.validTouch = true
        }
        else {
            self.validTouch = false
        }
    }
    
    func touchPlayer() {
        
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // if touch is valid, moving the icon along the touch point's trajectory
        if (validTouch) {
            let touch: UITouch = touches.first!
            let currentPoint = touch.location(in: self.view)
            var frame: CGRect = startFrame!
            frame.origin.x = startFrame!.origin.x + (currentPoint.x - startPoistion!.x)
            frame.origin.y = startFrame!.origin.y + (currentPoint.y - startPoistion!.y)
            player.frame = frame
            
            // in the circusmestance when the icon moving outside the valid range, evaluate that if should jump to
            // the next level or finishe the game
            if (!isValidRange()) {
                stopTimer()
                if (isFinished()) {
                    gameScore = Int(1000/timeCost)*currentLevel*currentLevel
                    UserDefaults.standard.set(gameScore, forKey: gameUser.name + "pipeScore")
                    if currentLevel < 3 { // show next level view
                        let highestLevel = UserDefaults.standard.integer(forKey: gameUser.name + "pipeLevel")
                        if (currentLevel+1) > highestLevel{
                            UserDefaults.standard.set(currentLevel+1, forKey: gameUser.name + "pipeLevel")
                        }
                        
                        let newLevel = UserDefaults.standard.integer(forKey: gameUser.name + "pipeLevel")
  
                        switch newLevel {
                        case 1:
                            gameInfo = [[LevelInfo(title: "Choose your character", images: ["animal1", "animal2","animal3", "animal4", "animal5","animal6","animal7","animal8","animal9","animal10"])],[LevelInfo(title: "Choose Level of Pipe Game", images: ["pipe_level1", "pipe_level2_lock", "pipe_level3_lock"])]]
                        case 2:
                            gameInfo = [[LevelInfo(title: "Choose your character", images: ["animal1", "animal2","animal3", "animal4", "animal5","animal6","animal7","animal8","animal9","animal10"])],[LevelInfo(title: "Choose Level of Pipe Game", images: ["pipe_level1", "pipe_level2", "pipe_level3_lock"])]]
                        case 3:
                            gameInfo = [[LevelInfo(title: "Choose your character", images: ["animal1", "animal2","animal3", "animal4", "animal5","animal6","animal7","animal8","animal9","animal10"])],[LevelInfo(title: "Choose Level of Pipe Game", images: ["pipe_level1", "pipe_level2", "pipe_level3"])]]
                        default:
                            break
                        }

                        let result = self.storyboard?.instantiateViewController(withIdentifier: "NotificationController") as! NotificationViewController;
                        self.present(result, animated: false, completion: nil)
                        UserDefaults.standard.set(currentLevel+1, forKey: gameUser.name + "pipeLevel")
                        result.showPipeGameNextLevel()

                    }
                    else {// show win view
                        let result = self.storyboard?.instantiateViewController(withIdentifier: "NotificationController") as! NotificationViewController;
                        self.present(result, animated: false, completion: nil)
                        result.showPipeGameWin()
                    }
                    
                    saveGameRecord()
                }
                else {
                    gameScore = 0
                    // show game over view
                    let result = self.storyboard?.instantiateViewController(withIdentifier: "NotificationController") as! NotificationViewController
                    self.present(result, animated: false, completion: nil)
                    result.showPipeGameOver()
                }
                saveGameRecord()
                validTouch = false
            }
        }

    }
    
    // evaluate whether the entire icon is within the range of path, compute 4 points of the icon
    func isValidRange() -> Bool {
        let frame = player.frame
        let leftTop = frame.origin
        
        var leftBottom = CGPoint()
        leftBottom.x = frame.origin.x
        leftBottom.y = frame.origin.y + frame.height
        
        var rightTop = CGPoint()
        rightTop.x = frame.origin.x + frame.width
        rightTop.y = frame.origin.y
        
        var rightBottom = CGPoint()
        rightBottom.x = frame.origin.x + frame.width
        rightBottom.y = frame.origin.y + frame.height
        
        
        if (currentPath?.contains(leftTop))! && (currentPath?.contains(leftBottom))! && (currentPath?.contains(rightTop))! && (currentPath?.contains(rightBottom))! {
            return true
            
        }
        
        return false
    }
    
    
    // evalue whether the icon exited from the designated port
    func isFinished() -> Bool {
        switch currentLevel {
        case 1:
            let point_x = player.frame.origin.x + player.frame.width
            if (point_x >= self.view.bounds.size.width - 5) {
                return true
            }
            else {
                return false;
            }
        case 2:
            let point_x = player.frame.origin.x + player.frame.width
            if (point_x >= self.view.bounds.size.width - 5) {
                return true
            }
            else {
                return false;
            }
        case 3:
            let point_y = player.frame.origin.y
            if (point_y < 335 * (self.view.bounds.size.height / 975)) {
                return true
            }
            else {
                return false;
            }
        default:
            return false
            
        }
    }

    

    
    func saveGameRecord() {
        var gameInfo = GameInfo()
        gameInfo.pid = gameUser.pid
        gameInfo.gid = 1
        gameInfo.level = currentLevel
        gameInfo.score = gameScore
        gameInfo.percentage = 100
        
        let bestScore =  UserDefaults.standard.integer(forKey: gameUser.name + "pipeScore")
        if gameScore > bestScore {
            UserDefaults.standard.set(gameScore, forKey: gameUser.name + "pipeScore")
        }
        
        
        dbConnect.insertGameRecord(gameInfo)

    }

    
    
    
    @IBAction func unwindPipeGameQuit(_ segue: UIStoryboardSegue) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func unwindPipeGameNextLevel(_ segue: UIStoryboardSegue) {
        if currentLevel < 3 {
            currentLevel += 1
            startGame(currentLevel)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    

}
