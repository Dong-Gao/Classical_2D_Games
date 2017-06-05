//
//  CardLevelViewController.swift
//  NPD_GAMES
//
//  Created by DongGao on 15/5/17.
//  Copyright © 2017 TheGreatMind. All rights reserved.
//

import UIKit

var cardChooseLevel: Int = -1
var cardLevelInfo = [[LevelInfo(title: "Choose Level of Card Game", images: ["drift_level1", "drift_level2","drift_level3"])]]

class CardLevelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var myLevel: Int = 1
    var myScore: Int = 0
    fileprivate var tableViewCellCoordinator: [Int:IndexPath] = [:]
    
    @IBOutlet weak var highestScore: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var start: UIButton!
    
    @IBAction func startGame(_ sender: UIButton) {
        if cardChooseLevel == -1 {
            let alert = UIAlertController(title: "Choose the game level", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if (cardChooseLevel+1) > myLevel {
            let alert = UIAlertController(title: "Cannot", message: "You have to compelete the former level", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else {
            performSegue(withIdentifier: "showCardGame", sender: self)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.separatorStyle = .none
        self.tableView!.register(UINib(nibName:"OneTableViewCell", bundle:nil), forCellReuseIdentifier:"oneCell")

        self.tableView!.estimatedRowHeight = 300.0
        self.tableView!.rowHeight = UITableViewAutomaticDimension
        
        let bestLevel = UserDefaults.standard.integer(forKey: gameUser.name+"cardLevel")
        if bestLevel > myLevel {
            myLevel = bestLevel
          }
        
        switch myLevel {
        case 1:
            cardLevelInfo = [[LevelInfo(title: "Choose Level of Card Game", images: ["drift_level1", "drift_level2_lock","drift_level3_lock"])]]
        case 2:
            cardLevelInfo = [[LevelInfo(title: "Choose Level of Card Game", images: ["drift_level1", "drift_level2","drift_level3_lock"])]]
        case 3:
            cardLevelInfo = [[LevelInfo(title: "Choose Level of Card Game", images: ["drift_level1", "drift_level2","drift_level3"])]]
        default:
            break
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        
        let bestLevel = UserDefaults.standard.integer(forKey: gameUser.name+"cardLevel")
        if bestLevel > myLevel {
            myLevel = bestLevel
        }
        
        let bestScore =  UserDefaults.standard.integer(forKey: gameUser.name + "cardScore")
        if bestScore > myScore {
            myScore = bestScore
        }
        
        highestScore.text = "Your highest Score is: \(myScore)"
        
        
    }
    
    
    
    lazy var didCollectionViewCellSelect: (([Int]) -> Void)? = { (collectionViewCellIndex) in
        cardChooseLevel = collectionViewCellIndex[1]
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "oneCell", for: indexPath)
                as! OneTableViewCell
            
            cell.didCollectionViewCellSelect = didCollectionViewCellSelect
            cell.frame = tableView.bounds
            cell.layoutIfNeeded()
            
            let tag = indexPath.section
            cell.collectionView.tag = tag
            tableViewCellCoordinator[tag] = indexPath
            
            cell.reloadData(title:cardLevelInfo[indexPath.section][indexPath.row].title, images: cardLevelInfo[indexPath.section][indexPath.row].images)
            cell.selectionStyle = .none
            return cell
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showCardGame" {
            let destVC = segue.destination as! CardViewController
            destVC.currentLevel = cardChooseLevel+1
        }
    }


}
