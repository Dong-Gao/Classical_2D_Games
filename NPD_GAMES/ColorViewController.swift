//
//  ColorViewController.swift
//  NPD_GAMES
//
//  Created by DongGao on 12/5/17.
//  Copyright © 2017 TheGreatMind. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var blackBtn: UIButton!
    @IBOutlet weak var redBtn: UIButton!
    @IBOutlet weak var brownBtn: UIButton!
    @IBOutlet weak var greenBtn: UIButton!
    @IBOutlet weak var pupleBtn: UIButton!
    @IBOutlet weak var blueBtn: UIButton!
    
    var currentLevel: Int = 1
    
    @IBAction func chooseColor(_ sender: UIButton) {
        let targetIndex = matchType == 0 ? colorTextIndex : colorIndex
        if targetIndex == sender.tag {  //Color match
            performNextTurn()
        }
        else {  //Color Mismatch
            performGameOver()
        }
        
    }
    
    
    let messages = ["Choose the meaning of the word", "Choose the color of the ink"]
    let colors = [UIColor.black, UIColor.red, UIColor.brown, UIColor.green, UIColor.purple, UIColor.blue]
    let texts = ["BLACK", "RED", "BROWN", "GREEN", "PURPLE", "BLUE"]
    var matchType = 0   // 0: meaning of the word; 1: color of the ink
    var colorIndex = 0
    var colorTextIndex = 0
    var currentScore = 0
    var timeLimit = 0
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        blackBtn.tag = 600
        redBtn.tag = 601
        brownBtn.tag = 602
        greenBtn.tag = 603
        pupleBtn.tag = 604
        blueBtn.tag = 605
    }

    
    override func viewDidAppear(_ animated: Bool) {
        runCardGame()
    }
    
    func runCardGame() {
        //Update the game score
        updateScore()
        
        //Randomly generate color and text
        colorIndex = Int(arc4random_uniform(6)+600)
        colorTextIndex = Int(arc4random_uniform(6)+600)
        
        //Present label ink color and text
        gameLabel.textColor = colors[colorIndex-600]
        gameLabel.text = texts[colorTextIndex-600]
        
        //Randomly choose match type
        matchType = Int(arc4random_uniform(2))
        updateMessage()
        
        //Initialize time limit and start timer
        timeLimit = computeTimeLimit()
        updateTime()
        timer?.invalidate() //Stop previous timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ColorViewController.onTimer), userInfo: nil, repeats: true) //Strat a timer
    }
    
    func updateScore() {
        scoreLabel.text = "Score: \(currentScore)"
    }
    
    
    func updateMessage(){
        messageLabel.text = matchType == 0 ? messages[0] : messages[1]
    }
    
    //With the increment of score, the time limit decreases.Down to the minimum 2s.
    func computeTimeLimit() -> Int {
        let decrease = Int(currentScore/20)
        var limit = 5 - decrease
        if limit < 3 {
            limit = 3
        }
        
        return limit
    }
    
    func updateTime() {
        timeLabel.text = "Time: \(timeLimit)s"
    }
    
    //Timer
    func onTimer() {
        timeLimit -= 1
        if timeLimit >= 0 {
            updateTime()
        }
        else {
            performGameOver()
            
        }
    }
    
    
    func performNextTurn() {
        currentScore += 10 //Add score by 10 each time
        runCardGame()
    }
    
    
    
    func performGameOver() {
        timer?.invalidate()  //Stop timer
        saveGameRecord()
        if let result = storyboard?.instantiateViewController(withIdentifier: "NotificationController") as? NotificationViewController {
            present(result, animated: true, completion: nil)
            result.showColorGameOver(currentScore)
            
        }
    }
    
    
    func saveGameRecord() {
        var gameInfo = GameInfo()
        gameInfo.pid = gameUser.pid
        gameInfo.gid = 5
        gameInfo.level = currentLevel
        gameInfo.time = ""
        gameInfo.score = currentScore
        gameInfo.percentage = 0
        
        let bestScore =  UserDefaults.standard.integer(forKey: gameUser.name + "colorScore")
        if currentScore > bestScore {
            UserDefaults.standard.set(currentScore, forKey: gameUser.name + "colorScore")
        }
        
        dbConnect.insertGameRecord(gameInfo)
        
    }
    
    @IBAction func unwindColorGameQuit(_ segue: UIStoryboardSegue) {
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
