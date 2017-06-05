//
//  BalloonGameScene.swift
//  NPD_GAMES
//
//  Created by DongGao on 17/5/17.
//  Copyright © 2017 TheGreatMind. All rights reserved.
//
import UIKit
import SpriteKit


class BalloonGameScene: SKScene, SKPhysicsContactDelegate {
    
    var viewController: UIViewController?
    
    let MASK_TOP: UInt32 = 0b1
    let MASK_BALLOON: UInt32 = 0b10
    let MASK_PROHIBIT: UInt32 = 0b100
    
    var btnTag = 0
    var balloons = [SKSpriteNode]()
    
    // Set background image and message label
    let bg = SKSpriteNode(imageNamed: "skyBg")
    let msg = SKLabelNode(text: "Message show")

    var blockSize: CGFloat = 0
    var currentlevel: Int = 1              // current game level, starts from 1.
    var timeSpan = 3.0                 // (seconds) time span between 2 consecutive balloons to fly

    var balloonSize = CGSize(width: 50.0, height: 85.0)     // balloon size
    var balloonCountPerRow: UInt32 = 0              // maximum number of balloon that a single row can contain, which will be initialized in constructor.
    var counter = 0         // it will be used for counting the number of tapped balloons.
    var eligible_count = 0  // the number of successfully tapped balloons required to pass the game.
    var timer: Timer?
    let gameStart = true
    var gameEnd = false     // whether game is finished (include gameover and pass)
    var prohibitedTag: Int = -1         // imageViews that have this tag value are prohibited to be tapped.
    var balloonSpeed: CGFloat = 10.0
    var touchedBalloon: SKSpriteNode?

    
    
    override func sceneDidLoad() {
        
        balloonCountPerRow = UInt32(UIScreen.main.bounds.width / balloonSize.width)
        
        // create an edge-based body that covers the bottom of the screen
        let TopRect = CGRect(x: self.frame.origin.x, y: self.frame.width-1, width: self.frame.size.width, height: 1)
        let top = SKSpriteNode()
        top.physicsBody = SKPhysicsBody(edgeLoopFrom: TopRect)
        top.physicsBody?.contactTestBitMask = MASK_TOP
        addChild(top)
        
        
    }
        

    override func didMove(to view: SKView) {
        //设置位置
        msg.position = CGPoint(x:self.frame.midX, y:self.frame.maxY-30)
        msg.fontSize = 30
        msg.fontColor = SKColor.red
        msg.fontName = "Avenir"
        msg.setScale(0.75)
        bg.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        bg.zPosition = -1
        
        self.addChild(msg)
        self.addChild(bg)
        //
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(timeInterval: spanTimer, target: self, selector: #selector(BalloonGameScene.runGame), userInfo: nil, repeats: true)
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let maskCode = contact.bodyA.contactTestBitMask | contact.bodyB.contactTestBitMask
        if maskCode == MASK_BALLOON | MASK_TOP {
            self.gameEnd = true
            timer?.invalidate()
            showGameOverView()
          
        }
        
        if maskCode == MASK_PROHIBIT | MASK_TOP {
            if contact.bodyA.contactTestBitMask == MASK_PROHIBIT {
                contact.bodyA.node?.removeFromParent()
            }
            if contact.bodyB.contactTestBitMask == MASK_PROHIBIT {
                contact.bodyB.node?.removeFromParent()
            }
        }


    }
    
    
    func startLevel1() {
        currentlevel = 1
        self.timeSpan = 5.0        // 5 second
        self.balloonSpeed = 30.0
        self.counter = 0            // initialize counter to be zero
        self.eligible_count = 5     // number of balloon required to be tapped
        self.prohibitedTag = -1     // -1 indicates none balloon to be prohibited
        self.gameEnd = false
        updateMessageLabel()
        
        timer = Timer.scheduledTimer(timeInterval: self.timeSpan, target: self, selector: #selector(self.createBalloon(_:)), userInfo: currentlevel, repeats: true)
    }
    
    func startLevel2() {
        currentlevel = 2
        
        self.timeSpan = 5.0
        self.balloonSpeed = 35.0
        self.counter = 0
        self.eligible_count = 5
        self.gameEnd = false
        self.prohibitedTag = Int(arc4random_uniform(UInt32(currentlevel)))
        updateMessageLabel()
        
        timer = Timer.scheduledTimer(timeInterval: self.timeSpan, target: self, selector: #selector(self.createBalloon(_:)), userInfo: currentlevel, repeats: true)

        
    }
    
    func startLevel3() {
        currentlevel = 3
        
        self.timeSpan = 4.0
        self.balloonSpeed = 40.0
        self.counter = 0
        self.eligible_count = 5
        self.gameEnd = false
        self.prohibitedTag = Int(arc4random_uniform(UInt32(currentlevel)))
        updateMessageLabel()
        
        timer = Timer.scheduledTimer(timeInterval: self.timeSpan, target: self, selector: #selector(self.createBalloon(_:)), userInfo: currentlevel, repeats: true)
        

    }
    
    func startLevel4() {
        currentlevel = 4
        
        self.timeSpan = 3.5
        self.balloonSpeed = 40.0
        self.counter = 0
        self.eligible_count = 5
        self.gameEnd = false
        self.prohibitedTag = Int(arc4random_uniform(UInt32(currentlevel)))
        updateMessageLabel()
        
        timer = Timer.scheduledTimer(timeInterval: self.timeSpan, target: self, selector: #selector(self.createBalloon(_:)), userInfo: currentlevel, repeats: true)
        

    }
    
    func startLevel5() {
        currentlevel = 5
        
        self.timeSpan = 3.0
        self.balloonSpeed = 40.0
        self.counter = 0
        self.eligible_count = 5
        self.gameEnd = false
        self.prohibitedTag = Int(arc4random_uniform(UInt32(currentlevel)))
        updateMessageLabel()
        
        timer = Timer.scheduledTimer(timeInterval: self.timeSpan, target: self, selector: #selector(self.createBalloon(_:)), userInfo: currentlevel, repeats: true)
        

    }
    
    func startLevel6() {
        currentlevel = 6
        
        self.timeSpan = 3.0
        self.balloonSpeed = 45.0
        self.counter = 0
        self.eligible_count = 5
        self.gameEnd = false
        self.prohibitedTag = Int(arc4random_uniform(UInt32(currentlevel)))
        updateMessageLabel()
        
        timer = Timer.scheduledTimer(timeInterval: self.timeSpan, target: self, selector: #selector(self.createBalloon(_:)), userInfo: currentlevel, repeats: true)
        

    }

    
    
    func updateMessageLabel() {
        switch (prohibitedTag) {
        case 0:
            msg.text = "Do not touch the BLUE balloon"
        case 1:
            msg.text = "Do not touch the YELLOW balloon"
        case 2:
            msg.text = "Do not touch the RED balloon"
        case 3:
            msg.text = "Do not touch the PINK balloon"
        case 4:
            msg.text = "Do not touch the ORANGE balloon"
        case 5:
            msg.text = "Do not touch the GREEN balloon"
        default:
            msg.text = ""
        }
    }
    
    
    
    func createBalloon(_ timer: Timer) {
        let colour = arc4random_uniform(UInt32(currentlevel))
        var balloon = SKSpriteNode()
        balloon.size = balloonSize
        balloon.name = "balloon"
        
        switch colour {
        case 0:
            balloon = SKSpriteNode(imageNamed: "b_blue")
            balloon.userData = ["tag": 0]
            break
        case 1:
            balloon = SKSpriteNode(imageNamed: "b_yellow")
            balloon.userData = ["tag": 1]
            break
        case 2:
            balloon = SKSpriteNode(imageNamed: "b_red")
            balloon.userData = ["tag": 2]
            break
        case 3:
            balloon = SKSpriteNode(imageNamed: "b_pink")
            balloon.userData = ["tag": 3]
            break
        case 4:
            balloon = SKSpriteNode(imageNamed: "b_orange")
            balloon.userData = ["tag": 4]
            break
        case 5:
            balloon = SKSpriteNode(imageNamed: "b_green")
            balloon.userData = ["tag": 5]
            break
        default:
            break
        }
        
        
        let point_x = CGFloat(arc4random_uniform(balloonCountPerRow)) * balloonSize.width
        balloon.position = CGPoint(x: point_x, y: 0)
        addChild(balloon)
        balloon.physicsBody = SKPhysicsBody(rectangleOf: balloon.frame.size)
        balloon.physicsBody!.allowsRotation = false
        balloon.physicsBody!.friction = 0.0
        balloon.physicsBody!.affectedByGravity = false
        balloon.physicsBody!.restitution = 1.0
        balloon.physicsBody?.linearDamping = 0.0
        if Int(colour) == prohibitedTag {
            balloon.physicsBody?.contactTestBitMask = MASK_PROHIBIT
        } else {
            balloon.physicsBody?.contactTestBitMask = MASK_BALLOON
        }
        balloon.physicsBody!.isDynamic = true
        balloon.physicsBody?.velocity = CGVector(dx: 0, dy: balloonSpeed)
        
        balloons.append(balloon)
        physicsWorld.contactDelegate = self

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.touchedBalloon = nil
        var touch: UITouch!
        touch = touches.first
        let touchPoint = touch.location(in: self)
        for balloon in balloons {
            if balloon.contains(touchPoint) {
                balloon.texture = SKTexture(imageNamed: "b_boom")
                self.touchedBalloon = balloon
                break
            }
        }
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if touchedBalloon != nil {
            let balloonTag = touchedBalloon!.userData!["tag"]! as! Int
            if balloonTag == self.prohibitedTag {
                self.gameEnd = true    // set game to be finished status, otherwise, the residual balloons will incure 'gameover' view popupped up
                timer?.invalidate()
                UserDefaults.standard.set(currentlevel, forKey: gameUser.name + "balloon")
                showGameOverView()
            }
            else {
                
                touchedBalloon?.run(SKAction.sequence([SKAction.wait(forDuration: 0.2)]))
                removeBalloon(touchedBalloon!)
                counter += 1
                if counter >= eligible_count {
                    self.gameEnd = true    // set game to be finished status, otherwise, the residual balloons will incure 'gameover' view popupped up
                    timer?.invalidate()
                    // has more levels to play.
                    if currentlevel < 6 {
                        showNextLevelView()
                        let highestLevel = UserDefaults.standard.integer(forKey: gameUser.name + "balloon")
                        if (currentlevel+1) > highestLevel{
                            UserDefaults.standard.set(currentlevel+1, forKey: gameUser.name + "balloon")
                        }
                        
                        let newLevel = UserDefaults.standard.integer(forKey: gameUser.name + "balloon")
                        
                        switch newLevel {
                        case 2:
                            balloonLevelInfo = [[LevelInfo(title: "Choose Level of Balloon Game", images: ["balloon_level1", "balloon_level2","balloon_level3_lock", "balloon_level4_lock", "balloon_level5_lock", "balloon_level6_lock"])]]
                        case 3:
                            balloonLevelInfo = [[LevelInfo(title: "Choose Level of Balloon Game", images: ["balloon_level1", "balloon_level2","balloon_level3", "balloon_level4_lock", "balloon_level5_lock", "balloon_level6_lock"])]]
                        case 4:
                            balloonLevelInfo = [[LevelInfo(title: "Choose Level of Balloon Game", images: ["balloon_level1", "balloon_level2","balloon_level3", "balloon_level4", "balloon_level5_lock", "balloon_level6_lock"])]]
                        case 5:
                            balloonLevelInfo = [[LevelInfo(title: "Choose Level of Balloon Game", images: ["balloon_level1", "balloon_level2","balloon_level3", "balloon_level4", "balloon_level5", "balloon_level6_lock"])]]
                        default:
                            break
                        }

                    }
                    else {
                        showGameWinView()
                    }
                    
                    saveGameRecord()
                    clearBalloon()  // clear all residual balloons that are still flying on the screen when the game is finished
                }
            }
        }

        
        
    }
    
    func removeBalloon(_ balloon: SKSpriteNode) {
        for index in 0 ..< balloons.count {
            if balloons[index] === balloon {
                balloons.remove(at: index)
                balloon.removeFromParent()
                break
            }
        }
    }
    
    
    func clearBalloon() {
        var count = balloons.count
        while count > 0 {
            balloons.last?.removeFromParent()
            balloons.removeLast()
            count -= 1
        }
    }
    


    
    func showRetryView() {
        let retryBtn = self.view!.viewWithTag(1) as! UIButton
        retryBtn.isHidden = false
        
        let quitBtn = self.view!.viewWithTag(3) as! UIButton
        quitBtn.isHidden = false
    }
    
    func showNextLevelView() {
        let nextBtn = self.view!.viewWithTag(2) as! UIButton
        nextBtn.isHidden = false
        let quitBtn = self.view!.viewWithTag(3) as! UIButton
        quitBtn.isHidden = false
    }
    
    func showGameWinView() {
        let quitBtn = self.view!.viewWithTag(3) as! UIButton
        quitBtn.isHidden = false
    }
    
    func showGameOverView() {
        let quitBtn = self.view!.viewWithTag(3) as! UIButton
        quitBtn.isHidden = false
    }

    func saveGameRecord() {
        var gameInfo = GameInfo()
        gameInfo.pid = gameUser.pid
        gameInfo.gid = 6
        gameInfo.level = currentlevel
        // The score and percentage is not the mesure of this game, the level is.
        gameInfo.score = 0
        gameInfo.percentage = 0        
        dbConnect.insertGameRecord(gameInfo)
    }


    
}














