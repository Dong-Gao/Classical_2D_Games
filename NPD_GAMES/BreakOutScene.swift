//
//  BreakOutScene.swift
//  NPD_GAMES
//
//  Created by DongGao on 20/5/17.
//  Copyright © 2017 TheGreatMind. All rights reserved.
//

import SpriteKit
import GameplayKit

class BreakOutScene: SKScene, SKPhysicsContactDelegate {
    
    let BallCategoryName        = "ball"
    let PaddleCategoryName      = "paddle"
    let BlockCategoryName       = "block"
    
    
    let MASK_BALL: UInt32 = 0b1
    let MASK_BLOCK: UInt32 = 0b10
    let MASK_PADDLE: UInt32 = 0b100
    let MASK_BOTTOM: UInt32 = 0b1000
    
    
    private var gameStarted: Bool = false
    private var velocity : CGFloat = 5.0
    private var paddleLength: CGFloat = 3.0
    var currentLevel = 1
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var ball : SKSpriteNode!
    private var spinnyNode : SKShapeNode?
    
    var score = 0
    var nextLevel = 0
    var highest = 0
    var level = 1
    var life = 2   // life left
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        //create a physics body that borders the screen
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        self.physicsBody = border
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self    // set contact delegate to itself in order to process contact events.
        
        setLifeLeft(life)
        startLevel1()
    }
    
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let ball = childNode(withName: BallCategoryName) as? SKSpriteNode {
            // apply an impulse to the ball to start game
            if !gameStarted {
                gameStarted = true
                ball.physicsBody!.applyImpulse(CGVector(dx: velocity, dy: -velocity))
            }
        }

    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let maskCode = contact.bodyA.contactTestBitMask | contact.bodyB.contactTestBitMask
        
        // react to the contact between ball and bottom
        if maskCode == MASK_BALL | MASK_BOTTOM {
            saveGameRecord()
            UserDefaults.standard.set(highest, forKey: gameUser.name + "breakoutScore")
            stopGame()
            life -= 1
            if life > 0 {  // has more life to play
                showRetryView()
            }
            else {
                showGameOverView()
            }
        }
        else if maskCode == MASK_BALL | MASK_BLOCK {
            
            if contact.bodyA.contactTestBitMask == MASK_BLOCK {
                contact.bodyA.node?.removeFromParent()
                }
            if contact.bodyB.contactTestBitMask == MASK_BLOCK {
                contact.bodyB.node?.removeFromParent()
                }
            
            score += 10
            if score > highest {
                highest = score
            }
            
            updateGameInfo()
            
            if score >= nextLevel {
                stopGame()
                
                if (currentLevel >= 2) {
                    showGameWinView()   // win the game
                }
                else {
                    showNextLevelView() // go to next level
                    
                    let highestLevel = UserDefaults.standard.integer(forKey: gameUser.name + "breakoutLevel")
                    if (currentLevel+1) > highestLevel{
                        UserDefaults.standard.set(currentLevel+1, forKey: gameUser.name + "breakoutLevel")
                    }
                    
                    let newLevel = UserDefaults.standard.integer(forKey: gameUser.name + "breakoutLevel")
                    switch newLevel {
                    case 1:
                        breakOutLevelInfo = [[LevelInfo(title: "Choose Level of Break Out Game", images: ["breakout_level1", "breakout_level2_lock"])]]
                    case 2:
                        breakOutLevelInfo = [[LevelInfo(title: "Choose Level of Break Out Game", images: ["breakout_level1", "breakout_level2"])]]
                    default:
                        break
                    }

                }
                
            }

            
            
        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameStarted {
            let paddle = childNode(withName: PaddleCategoryName) as! SKSpriteNode
            
            let touch = touches.first!
            let touchLocation = touch.location(in: self)
            let previousLocation = touch.previousLocation(in: self)
            
            var paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            
            paddleX = max(paddleX, paddle.frame.width / 2)
            paddleX = min(paddleX, self.size.width - paddle.frame.width / 2)
            
            paddle.position = CGPoint(x: paddleX, y: paddle.position.y)
        }

        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if gameStarted {
            let ball = childNode(withName: BallCategoryName) as! SKSpriteNode
            
            // control bouncing direction
            if ball.physicsBody!.velocity.dx == 0 {
                ball.physicsBody!.applyImpulse(CGVector(dx: velocity, dy: 0))
            }
            
            if (ball.physicsBody!.velocity.dy == 0) {
                ball.physicsBody!.applyImpulse(CGVector(dx: 0, dy: -velocity))
            }
            
            // control speed
            let maxSpeed: CGFloat = 550.0
            let speed = sqrt(ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx + ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy)
            
            if speed > maxSpeed {
                ball.physicsBody!.linearDamping = 0.4
            }
            else {
                ball.physicsBody!.linearDamping = 0.0
            }
        }

    }

    
    func stopGame() {
        self.removeAllChildren()
        self.gameStarted = false
    }
    
    
    func getCurrentLevel() -> Int {
        return currentLevel
    }
    
    func getLifeLeft() -> Int {
        return life
    }
    
    func setLifeLeft(_ live: Int) {
        life = live
    }

    
    func startLevel1() {
        currentLevel = 1
        paddleLength = 3
        nextLevel = 800
        level = 1
        score = 0
        
        addElements()
        updateGameInfo()
    }
    
    func startLevel2() {
        currentLevel = 2
        paddleLength = 2
        nextLevel = 1600
        level = 2
        score = 0
        
        addElements()
        updateGameInfo()
    }
    
    func updateGameInfo() {
        
        let scoreLabel = self.view!.superview!.viewWithTag(4) as! UILabel
        let nextLabel = self.view!.superview!.viewWithTag(5) as! UILabel
        let levelLabel = self.view!.superview!.viewWithTag(6) as! UILabel
        let highestLabel = self.view!.superview!.viewWithTag(7) as! UILabel
        let liveLabel = self.view!.superview!.viewWithTag(8) as! UILabel

        scoreLabel.text  = "Score: \(score)"
        nextLabel.text   = "Next: \(nextLevel)"
        highestLabel.text = "Highest: \(highest)"
        levelLabel.text  = "Level: \(level)"
        liveLabel.text   = "Life: \(life)"
    }
    
    
    func addElements() {
        let span_x = self.frame.width / 12.0
        let span_y = self.frame.height / 40.0
        
        let blockWidth = span_x * 0.9
        let blockHeight = span_y * 0.9
        
        // create blocks
        for i in 1...10 {
            for j in 0...7 {
                let block = SKSpriteNode(imageNamed: "block")
                block.size = CGSize(width: blockWidth, height: blockHeight)
                
                // Set position of a block. The position propert indicates the center of the block.
                // That's why (+0.5)
                let x = (CGFloat(i) + 0.5) * span_x
                let y = self.frame.height - (CGFloat(j) + 0.5) * span_y
                block.position = CGPoint(x: x, y: y)
                
                block.physicsBody = SKPhysicsBody(rectangleOf: block.frame.size)
                block.physicsBody!.allowsRotation = false
                block.physicsBody!.friction = 0.0
                block.physicsBody!.affectedByGravity = false
                block.physicsBody!.restitution = 1.0
                block.physicsBody!.isDynamic = false
                block.name = BlockCategoryName
                block.physicsBody?.contactTestBitMask = MASK_BLOCK
                addChild(block)
            }
        }
        
        // create paddle
        let paddle = SKSpriteNode(color: UIColor.blue, size: CGSize(width: blockWidth * paddleLength, height: blockHeight))
        paddle.position = CGPoint(x: self.frame.midX, y: self.frame.height / 20.0)
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.frame.size)
        paddle.physicsBody!.allowsRotation = false
        paddle.physicsBody!.friction = 0.0
        paddle.physicsBody!.restitution = 1.0
        paddle.physicsBody!.affectedByGravity = false
        paddle.physicsBody!.isDynamic = false
        paddle.name = PaddleCategoryName
        paddle.physicsBody?.contactTestBitMask = MASK_PADDLE
        addChild(paddle)
        
        // create ball
        let ball = SKSpriteNode(imageNamed: "breakBall")
        ball.size = CGSize(width: span_y, height: span_y)
        ball.position = CGPoint(x: paddle.position.x, y: paddle.position.y + ball.size.height)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: span_y * 0.5)
        ball.physicsBody!.allowsRotation = false
        ball.physicsBody!.friction = 0.0
        ball.physicsBody!.restitution = 1.0
        ball.physicsBody!.affectedByGravity = false
        ball.physicsBody!.linearDamping = 0.0
        ball.physicsBody!.angularDamping = 0.0
        ball.physicsBody!.isDynamic = true
        ball.name = BallCategoryName
        ball.physicsBody?.contactTestBitMask = MASK_BALL
        addChild(ball)
        
        // create an edge-based body that covers the bottom of the screen
        let bottomRect = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        bottom.physicsBody?.contactTestBitMask = MASK_BOTTOM
        addChild(bottom)
        
        physicsWorld.contactDelegate = self

    }
    
    func showRetryView() {
        let retryBtn = self.view!.superview!.viewWithTag(1) as! UIButton
        retryBtn.isHidden = false
        
        let quitBtn = self.view!.superview!.viewWithTag(3) as! UIButton
        quitBtn.isHidden = false
    }
    
    func showNextLevelView() {
        let nextBtn = self.view!.superview!.viewWithTag(2) as! UIButton
        nextBtn.isHidden = false
        
        let quitBtn = self.view!.superview!.viewWithTag(3) as! UIButton
        quitBtn.isHidden = false
    }
    
    func showGameWinView() {
        let quitBtn = self.view!.superview!.viewWithTag(3) as! UIButton
        quitBtn.isHidden = false
    }
    
    func showGameOverView() {
        let quitBtn = self.view!.superview!.viewWithTag(3) as! UIButton
        quitBtn.isHidden = false
    }
    
    

    func saveGameRecord() {
        var gameInfo = GameInfo()
        gameInfo.pid = gameUser.pid
        gameInfo.gid = 4
        gameInfo.level = currentLevel
        gameInfo.time = ""
        gameInfo.score = highest
        gameInfo.percentage = 0
        
        let bestScore =  UserDefaults.standard.integer(forKey: gameUser.name + "breakoutScore")
        if highest > bestScore {
            UserDefaults.standard.set(highest, forKey: gameUser.name + "breakoutScore")
        }
        
        dbConnect.insertGameRecord(gameInfo)
        
    }

    

}
