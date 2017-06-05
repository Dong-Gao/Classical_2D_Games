//
//  CardViewController.swift
//  NPD_GAMES
//
//  Created by DongGao on 12/5/17.
//  Copyright © 2017 TheGreatMind. All rights reserved.
//

import UIKit


class CardViewController: UIViewController {
    
    @IBOutlet weak var stateMessage: UILabel!
    @IBOutlet weak var seedCard: UIImageView!
    @IBOutlet weak var cardBtn1: UIButton!
    @IBOutlet weak var cardBtn2: UIButton!
    @IBOutlet weak var cardBtn3: UIButton!
    @IBOutlet weak var cardBtn4: UIButton!
    @IBOutlet weak var cardBtn5: UIButton!
    @IBOutlet weak var cardBtn6: UIButton!
    @IBOutlet weak var cardBtn7: UIButton!
    @IBOutlet weak var cardBtn8: UIButton!
    @IBOutlet weak var cardBtn9: UIButton!
    
    var seedCardList = [UIImageView]()
    //Store a library of images
    var cardChooseList = [UIImage]()
    let cardBgImage = UIImage(named: "cardBg")
    
    var timeLimits = [3.0,3.0,3.0,2.0,2.0,2.0,1.0,1.0,1.0]
    var guessTimes = [1,2,3]
    
    var currentLevel: Int = 1
    var currentSublevel: Int = 0
    var tryTimes = 0

    
    @IBAction func chooseCard(_ sender: UIButton) {
        // process correct guess
        if (sender.tag == seedCard.tag) {
            
            if (currentSublevel < 9) {
                runGame(currentSublevel + 1)    // go to next sub-level
            }
            else {
                saveGameRecord()
                let result = self.storyboard?.instantiateViewController(withIdentifier: "NotificationController") as! NotificationViewController;
                self.present(result, animated: false, completion: nil)
                // has more level to play
                if (currentLevel < 3) {
                    
                    let highestLevel = UserDefaults.standard.integer(forKey: gameUser.name + "cardLevel")
                    if (currentLevel+1) > highestLevel{
                        UserDefaults.standard.set(currentLevel+1, forKey: gameUser.name + "cardLevel")
                    }
                    
                    let newLevel = UserDefaults.standard.integer(forKey: gameUser.name + "cardLevel")
                    
                    switch newLevel {
                    case 1:
                        cardLevelInfo = [[LevelInfo(title: "Choose Level of Card Game", images: ["drift_level1", "drift_level2_lock","drift_level3_lock"])]]
                    case 2:
                        cardLevelInfo = [[LevelInfo(title: "Choose Level of Card Game", images: ["drift_level1", "drift_level2","drift_level3_lock"])]]
                    case 3:
                        cardLevelInfo = [[LevelInfo(title: "Choose Level of Card Game", images: ["drift_level1", "drift_level2","drift_level3"])]]
                    default:
                        break
                    }
                    
                    saveGameRecord()
                    result.showCardGameNextLevel()
                }
                     // no more level
                else {
                    saveGameRecord()
                    result.showCardGameWin()
                }
            }
        }
            // process wrong guess
        else {
            // check whether it's exceeded max guess times
            if (tryTimes < guessTimes[currentLevel - 1]) {
                sender.isHighlighted = true
                tryTimes += 1
            }
            else {
                let result = self.storyboard?.instantiateViewController(withIdentifier: "NotificationController") as! NotificationViewController;
                self.present(result, animated: false, completion: nil)
                result.showCardGameReset()
                saveGameRecord()
            }
        }

        
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Load 54 cards
        for index in 0...53 {
            let card = UIImage(named: "Poker-" + String(index))
            cardChooseList.append(card!)
        }
        
        startLevel1()
        
    }
    
    /*
    override func viewDidAppear(_ animated: Bool) {
        if currentLevel == 1 {
            startLevel1()
        }
    }
 */
    
    func startLevel1() {
        currentLevel = 1
        
        cardBtn1.setImage(cardBgImage, for: .normal)
        cardBtn2.setImage(cardBgImage, for: .normal)
        cardBtn3.setImage(cardBgImage, for: .normal)
        cardBtn4.isHidden = true
        cardBtn5.isHidden = true
        cardBtn6.isHidden = true
        cardBtn7.isHidden = true
        cardBtn8.isHidden = true
        cardBtn9.isHidden = true
        
        runGame(1)
        
    }
    
    func startLevel2() {
        currentLevel = 2
        cardBtn1.setImage(cardBgImage, for: .normal)
        cardBtn2.setImage(cardBgImage, for: .normal)
        cardBtn3.setImage(cardBgImage, for: .normal)
        cardBtn4.isHidden = false
        cardBtn5.isHidden = false
        cardBtn6.isHidden = false
        cardBtn4.setImage(cardBgImage, for: .normal)
        cardBtn5.setImage(cardBgImage, for: .normal)
        cardBtn6.setImage(cardBgImage, for: .normal)
        cardBtn7.isHidden = true
        cardBtn8.isHidden = true
        cardBtn9.isHidden = true
        runGame(1)
    }
    
    
    func startLevel3() {
        currentLevel = 3
        cardBtn1.setImage(cardBgImage, for: .normal)
        cardBtn2.setImage(cardBgImage, for: .normal)
        cardBtn3.setImage(cardBgImage, for: .normal)
        cardBtn4.setImage(cardBgImage, for: .normal)
        cardBtn5.setImage(cardBgImage, for: .normal)
        cardBtn6.setImage(cardBgImage, for: .normal)
        cardBtn7.isHidden = false
        cardBtn8.isHidden = false
        cardBtn9.isHidden = false
        cardBtn7.setImage(cardBgImage, for: .normal)
        cardBtn8.setImage(cardBgImage, for: .normal)
        cardBtn9.setImage(cardBgImage, for: .normal)
        
        runGame(1)
    }
    
    
    func runGame(_ subLevel: Int) {
        currentSublevel = subLevel
        tryTimes = 1
        updateStateMessage()
        //Randomly choose cards to show
        var tempList = [UIImage](cardChooseList) // create a temporary poker list, which is copied from the PokerList
        var cards = [UIImage]()
        var indexes = [Int]()
        
        switch currentLevel {
        case 1:
            for _ in 0...2 {
                let index = Int(arc4random_uniform(UInt32(tempList.count)))
                cards.append(tempList[index])
                indexes.append(index)
                tempList.remove(at: index)
            }
            cardBtn1.setImage(cards[0], for: .normal)
            cardBtn1.tag = indexes[0]
            cardBtn2.setImage(cards[1], for: .normal)
            cardBtn2.tag = indexes[1]
            cardBtn3.setImage(cards[2], for: .normal)
            cardBtn3.tag = indexes[2]
            
        case 2:
            for _ in 0...5 {
                let index = Int(arc4random_uniform(UInt32(tempList.count)))
                cards.append(tempList[index])
                indexes.append(index)
                tempList.remove(at: index)
            }
            cardBtn1.setImage(cards[0], for: .normal)
            cardBtn1.tag = indexes[0]
            cardBtn2.setImage(cards[1], for: .normal)
            cardBtn2.tag = indexes[1]
            cardBtn3.setImage(cards[2], for: .normal)
            cardBtn3.tag = indexes[2]
            cardBtn4.setImage(cards[3], for: .normal)
            cardBtn4.tag = indexes[3]
            cardBtn5.setImage(cards[4], for: .normal)
            cardBtn5.tag = indexes[4]
            cardBtn6.setImage(cards[5], for: .normal)
            cardBtn6.tag = indexes[5]
        case 3:
            for _ in 0...8 {
                let index = Int(arc4random_uniform(UInt32(tempList.count)))
                cards.append(tempList[index])
                indexes.append(index)
                tempList.remove(at: index)
            }
            cardBtn1.setImage(cards[0], for: .normal)
            cardBtn1.tag = indexes[0]
            cardBtn2.setImage(cards[1], for: .normal)
            cardBtn2.tag = indexes[1]
            cardBtn3.setImage(cards[2], for: .normal)
            cardBtn3.tag = indexes[2]
            cardBtn4.setImage(cards[3], for: .normal)
            cardBtn4.tag = indexes[3]
            cardBtn5.setImage(cards[4], for: .normal)
            cardBtn5.tag = indexes[4]
            cardBtn6.setImage(cards[5], for: .normal)
            cardBtn6.tag = indexes[5]
            cardBtn7.setImage(cards[6], for: .normal)
            cardBtn7.tag = indexes[6]
            cardBtn8.setImage(cards[7], for: .normal)
            cardBtn8.tag = indexes[7]
            cardBtn9.setImage(cards[8], for: .normal)
            cardBtn9.tag = indexes[8]
        default:
            break
        }
        
        //Randomly choose a card as seed
        let index = Int(arc4random_uniform(UInt32(cards.count)))
        seedCard.image = cards[index]
        seedCard.tag = indexes[index]
        
        //Build a timer to turn over cards
        Timer.scheduledTimer(timeInterval: timeLimits[subLevel-1], target: self, selector: #selector(CardViewController.turnOverCards), userInfo: nil, repeats: false)
        
        
    }
    
    
    func turnOverCards() {
        switch currentLevel {
        case 1:
            cardBtn1.setImage(cardBgImage, for: .normal)
            cardBtn2.setImage(cardBgImage, for: .normal)
            cardBtn3.setImage(cardBgImage, for: .normal)
           
        case 2:
            cardBtn1.setImage(cardBgImage, for: .normal)
            cardBtn2.setImage(cardBgImage, for: .normal)
            cardBtn3.setImage(cardBgImage, for: .normal)
            cardBtn4.setImage(cardBgImage, for: .normal)
            cardBtn5.setImage(cardBgImage, for: .normal)
            cardBtn6.setImage(cardBgImage, for: .normal)

        case 3:
            cardBtn1.setImage(cardBgImage, for: .normal)
            cardBtn2.setImage(cardBgImage, for: .normal)
            cardBtn3.setImage(cardBgImage, for: .normal)
            cardBtn4.setImage(cardBgImage, for: .normal)
            cardBtn5.setImage(cardBgImage, for: .normal)
            cardBtn6.setImage(cardBgImage, for: .normal)
            cardBtn7.setImage(cardBgImage, for: .normal)
            cardBtn8.setImage(cardBgImage, for: .normal)
            cardBtn9.setImage(cardBgImage, for: .normal)
        default:
            break
        }

    }
    
    func updateStateMessage() {
        stateMessage.text = "Question \(currentSublevel) of 9 of level \(currentLevel)"
    }
    
    
    
    @IBAction func unwindCardGameReset(_ segue: UIStoryboardSegue) {
        startLevel1()
    }
    
    @IBAction func unwindCardGameNextLevel(_ segue: UIStoryboardSegue) {
        switch currentLevel {
        case 1:
            startLevel2()
        case 2:
            startLevel3()
        default:
            break
        }
        
    }
    
    @IBAction func unwindCardGameQuit(_ segue: UIStoryboardSegue) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    func saveGameRecord() {
        var gameInfo = GameInfo()
        gameInfo.pid = gameUser.pid
        gameInfo.gid = 3
        gameInfo.level = currentLevel
        gameInfo.time = ""
        gameInfo.score = (currentLevel - 1) * 20 + (currentSublevel - 1) * 10
        gameInfo.percentage = 0
        
        let bestScore =  UserDefaults.standard.integer(forKey: gameUser.name + "cardScore")
        let score = (currentLevel - 1) * 20 + (currentSublevel - 1) * 10
        if score > bestScore {
            UserDefaults.standard.set(score, forKey: gameUser.name + "cardScore")
        }
        
        
        dbConnect.insertGameRecord(gameInfo)
        
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }


}
