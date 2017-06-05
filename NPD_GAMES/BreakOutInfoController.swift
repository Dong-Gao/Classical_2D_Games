//
//  BreakOutInfoController.swift
//  NPD_GAMES
//
//  Created by DongGao on 20/5/17.
//  Copyright © 2017 TheGreatMind. All rights reserved.
//

import UIKit

var breakOutChooseLevel: Int = -1
var breakOutLevelInfo = [[LevelInfo(title: "Choose Level of Break Out Game", images: ["breakout_level1", "breakout_level2"])]]

class BreakOutInfoController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var myLevel: Int = 1
    var myScore: Int = 0
    fileprivate var tableViewCellCoordinator: [Int:IndexPath] = [:]

    @IBOutlet weak var highestScore: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var start: UIButton!
    
    @IBAction func startGame(_ sender: UIButton) {
        if breakOutChooseLevel == -1 {
            let alert = UIAlertController(title: "Choose the game level", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if (breakOutChooseLevel+1) > myLevel {
            let alert = UIAlertController(title: "Cannot", message: "You have to compelete the former level", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else {
            performSegue(withIdentifier: "showBreakOut", sender: self)
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
        
        let bestLevel = UserDefaults.standard.integer(forKey: gameUser.name+"breakoutLevel")
        if bestLevel > myLevel {
            myLevel = bestLevel
            
        }
        switch myLevel {
        case 1:
            breakOutLevelInfo = [[LevelInfo(title: "Choose Level of Break Out Game", images: ["breakout_level1", "breakout_level2_lock"])]]
        case 2:
            breakOutLevelInfo = [[LevelInfo(title: "Choose Level of Break Out Game", images: ["breakout_level1", "breakout_level2"])]]
        default:
            break
        }

    }

    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        
        let bestScore = UserDefaults.standard.integer(forKey: gameUser.name+"breakoutScore")
        if bestScore > myScore {
            myScore = bestScore
        }
        
        highestScore.text = "Your Highest Score is: \(myScore)"
        
        let bestLevel = UserDefaults.standard.integer(forKey: gameUser.name+"breakoutLevel")
        if bestLevel > myLevel {
            myLevel = bestLevel
            
        }
        
        
        
    }
    
    lazy var didCollectionViewCellSelect: (([Int]) -> Void)? = { (collectionViewCellIndex) in
        breakOutChooseLevel = collectionViewCellIndex[1]
        
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
            
            cell.reloadData(title:breakOutLevelInfo[indexPath.section][indexPath.row].title, images: breakOutLevelInfo[indexPath.section][indexPath.row].images)
            cell.selectionStyle = .none
            return cell
    }


    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showBreakOut" {
            let destVC = segue.destination as! BreakOutViewController
            destVC.currentLevel = breakOutChooseLevel+1
        }
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
