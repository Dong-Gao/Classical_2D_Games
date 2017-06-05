//
//  DriftBallViewController.swift
//  NPD_GAMES
//
//  Created by DongGao on 12/5/17.
//  Copyright © 2017 TheGreatMind. All rights reserved.
//

import UIKit
import CoreMotion

class DriftBallViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var circleBg: UIImageView!
    @IBOutlet weak var ball: UIImageView!
    
    var moveTimer: Timer?     // used for updating movement of the ball
    var countingTimer: Timer? // used for updating remaining time on the screen
    var point_x: CGFloat?
    var point_y: CGFloat?
    var velocity: CGFloat?
    var timeLimit: Float = 20.0 // seconds
    var circleradius: CGFloat?
    var circlePath: CGMutablePath?
    let manager = CMMotionManager()
    var currentLevel: Int = 1

    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startGame(currentLevel)
    }
    
 
    
    func updateRemainingTime() {
        self.timeLabel.text = String(format: "Time remaining: %.1f seconds", timeLimit)
    }
    
    func countDown() {
        timeLimit -= 0.1
        updateRemainingTime()
        
        if (timeLimit <= 0) {
            gameOver(true)
        }
    }

    // reset background circle and the position of the ball
    func reset() {
        let center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        
        point_x = center.x
        point_y = center.y
        
        // create a logic circle
        circlePath = CGMutablePath()
        circlePath?.addArc(center: CGPoint(x: center.x, y: center.y), radius: circleradius!, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: false)
        
        // resize circle background
        self.circleBg.frame = CGRect(x: 0, y: 0, width: self.circleradius! * 2, height: self.circleradius! * 2)
        self.circleBg.center = center
        
        // start accelerometer
        if (manager.isAccelerometerAvailable) {
            manager.accelerometerUpdateInterval = 0.01
            manager.startAccelerometerUpdates()
            
            // start timers
            moveTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(DriftBallViewController.move), userInfo: nil, repeats: true)
            countingTimer  = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(DriftBallViewController.countDown), userInfo: nil, repeats: true)
        }
        else {
            // give message to user that the accelerometer is not available
            print("not avaliable")
        }
        
        
    }
    
    func startGame(_ level: Int) {
        timeLimit = 20.0  // reset time
        self.currentLevel = level
        switch currentLevel {
        case 1:
            startLevel1()
        case 2:
            startLevel2()
        case 3:
            startLevel3()
        case 4:
            startLevel4()
        case 5:
            startLevel5()
        default:
            break
        }
    }

    
    
    func startLevel1() {
        self.velocity = 1.5
        self.circleradius = self.view.bounds.width * 0.4
        
        reset()
    }
    
    func startLevel2() {
        self.velocity = 2.0
        self.circleradius = self.view.bounds.width * 0.35
        
        reset()
    }
    
    func startLevel3() {
        self.velocity = 2.5
        self.circleradius = self.view.bounds.width * 0.3
        
        reset()
    }
    
    func startLevel4() {
        self.velocity = 3.0
        self.circleradius = self.view.bounds.width * 0.25
        
        reset()
    }
    
    func startLevel5() {
        self.velocity = 3.5
        self.circleradius = self.view.bounds.width * 0.2
        
        reset()
    }
    
    func move() {
        let data = manager.accelerometerData
        
        if (data != nil) {
            point_x! += CGFloat((data?.acceleration.x)!) * self.velocity!
            point_y! -= CGFloat((data?.acceleration.y)!) * self.velocity!
            
            ball.center.x = point_x!
            ball.center.y = point_y!
        }
        
        // whether the ball center is within the circle background
        if (!(circlePath?.contains(ball.center))!) {
            gameOver(false)
        }
    }

    func gameOver(_ isOver: Bool) {
        // stop timers
        moveTimer?.invalidate()
        countingTimer?.invalidate()
        
        // popup window
        if isOver {
            let result = self.storyboard?.instantiateViewController(withIdentifier: "NotificationController") as! NotificationViewController;
            self.present(result, animated: false, completion: nil)
            // has more level to play
            if (self.currentLevel < 5) {
                let highestLevel = UserDefaults.standard.integer(forKey: gameUser.name + "driftLevel")
                if (currentLevel+1) > highestLevel{
                    UserDefaults.standard.set(currentLevel+1, forKey: gameUser.name + "driftLevel")
                }
                
                let newLevel = UserDefaults.standard.integer(forKey: gameUser.name + "driftLevel")
                switch newLevel {
                case 1:
                    driftLevelInfo = [[LevelInfo(title: "Choose Level of Drift Ball Game", images: ["drift_level1", "drift_level2_lock","drift_level3_lock", "drift_level4_lock", "drift_level5_lock"])]]
                case 2:
                    driftLevelInfo = [[LevelInfo(title: "Choose Level of Drift Ball Game", images: ["drift_level1", "drift_level2","drift_level3_lock", "drift_level4_lock", "drift_level5_lock"])]]
                case 3:
                    driftLevelInfo = [[LevelInfo(title: "Choose Level of Drift Ball Game", images: ["drift_level1", "drift_level2","drift_level3", "drift_level4_lock", "drift_level5_lock"])]]
                case 4:
                    driftLevelInfo = [[LevelInfo(title: "Choose Level of Drift Ball Game", images: ["drift_level1", "drift_level2","drift_level3", "drift_level4", "drift_level5_lock"])]]
                case 5:
                    driftLevelInfo = [[LevelInfo(title: "Choose Level of Drift Ball Game", images: ["drift_level1", "drift_level2","drift_level3", "drift_level4", "drift_level5"])]]
                default:
                    break
                }
                result.showDriftGameNextLevel(20.0)
            }
                // no more level to play
            else{
                result.showDriftGameWin()
            }
        }
        else {
            let result = self.storyboard?.instantiateViewController(withIdentifier: "NotificationController") as! NotificationViewController;
            self.present(result, animated: false, completion: nil)
            result.showDriftGameOver(20 - timeLimit)
            
            saveGameRecord()
        }
    }

    
    
    
    
    
    func saveGameRecord() {
        var gameInfo = GameInfo()
        gameInfo.pid = gameUser.pid
        gameInfo.gid = 2
        gameInfo.level = currentLevel
        gameInfo.time = ""
        gameInfo.score = Int(20 - Int(timeLimit) + currentLevel * 20)
        gameInfo.percentage = 0
        dbConnect.insertGameRecord(gameInfo)
        
    }
    
    @IBAction func unwindDriftGameReset(_ segue: UIStoryboardSegue) {
        startGame(1)
    }
    
    @IBAction func unwindDriftGameRetry(_ segue: UIStoryboardSegue) {
        startGame(currentLevel)
    }
    
    @IBAction func unwindDriftGameNextLevel(_ segue: UIStoryboardSegue) {
        if (self.currentLevel < 5) {
            startGame(currentLevel+1)
        }
    }
    
    @IBAction func unwindDriftGameQuit(_ segue: UIStoryboardSegue) {
        self.dismiss(animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override var prefersStatusBarHidden : Bool {
        return true
    }


}
