//
//  PipeLevelViewController.swift
//  NPD_GAMES
//
//  Created by DongGao on 1/5/17.
//  Copyright © 2017 TheGreatMind. All rights reserved.
//

import UIKit

var pipeGamecharacter: Int = -1
var pipeChooseLevel: Int = -1
var gameInfo = [[LevelInfo(title: "Choose your character", images: ["animal1", "animal2","animal3", "animal4", "animal5","animal6","animal7","animal8","animal9","animal10"])],[LevelInfo(title: "Choose Level of Pipe Game", images: ["pipe_level1", "pipe_level2_lock", "pipe_level3_lock"])]]


class PipeLevelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Pipe game characters and levels information
    
    var sectionTitle = ["Game Characters","Game Levels"]
    var myScore: Int = 0
    var myLevel: Int = 1
    fileprivate var tableViewCellCoordinator: [Int:IndexPath] = [:]
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var highestScore: UILabel!    
    @IBOutlet weak var bestLevel: UILabel!
    @IBOutlet weak var start: UIButton!
    
    @IBAction func startGame(_ sender: UIButton) {
        if pipeGamecharacter == -1 {
            let alert = UIAlertController(title: "Choose your game character", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if pipeChooseLevel == -1 {
            let alert = UIAlertController(title: "Choose the game level", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if (pipeChooseLevel+1) > myLevel {
            let alert = UIAlertController(title: "Cannot", message: "You have to compelete the former level", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else {
            performSegue(withIdentifier: "showPipeGame", sender: self)
        }

        
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set tableview delegate
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.separatorStyle = .none
        
        self.tableView!.register(UINib(nibName:"PipeTableViewCell", bundle:nil), forCellReuseIdentifier:"myCell")
        
        self.tableView!.estimatedRowHeight = 300.0
        self.tableView!.rowHeight = UITableViewAutomaticDimension
        
        let highestLevel = UserDefaults.standard.integer(forKey: gameUser.name + "pipeLevel")
        if highestLevel > myLevel {
            myLevel = highestLevel
        }

        switch myLevel {
        case 1:
            gameInfo = [[LevelInfo(title: "Choose your character", images: ["animal1", "animal2","animal3", "animal4", "animal5","animal6","animal7","animal8","animal9","animal10"])],[LevelInfo(title: "Choose Level of Pipe Game", images: ["pipe_level1", "pipe_level2_lock", "pipe_level3_lock"])]]
        case 2:
            gameInfo = [[LevelInfo(title: "Choose your character", images: ["animal1", "animal2","animal3", "animal4", "animal5","animal6","animal7","animal8","animal9","animal10"])],[LevelInfo(title: "Choose Level of Pipe Game", images: ["pipe_level1", "pipe_level2", "pipe_level3_lock"])]]
        case 3:
            gameInfo = [[LevelInfo(title: "Choose your character", images: ["animal1", "animal2","animal3", "animal4", "animal5","animal6","animal7","animal8","animal9","animal10"])],[LevelInfo(title: "Choose Level of Pipe Game", images: ["pipe_level1", "pipe_level2", "pipe_level3"])]]
        default:
            break
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        let bestScore =  UserDefaults.standard.integer(forKey: gameUser.name + "pipeScore")
        if bestScore > myScore {
            myScore = bestScore
        }
        highestScore.text = "Your Highest Score: \(myScore)"
        
        let highestLevel = UserDefaults.standard.integer(forKey: gameUser.name + "pipeLevel")
        if highestLevel > myLevel {
            myLevel = highestLevel
        }
        
        bestLevel.text = "Your Best Level: \(myLevel)"
        
    }
    
    lazy var didCollectionViewCellSelect: (([Int]) -> Void)? = { (collectionViewCellIndex) in
        switch collectionViewCellIndex[0] {
        case 0:
            pipeGamecharacter = collectionViewCellIndex[1]
        case 1:
            pipeChooseLevel = collectionViewCellIndex[1]
        default:
            break
            
        }
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
                as! PipeTableViewCell
            
            cell.didCollectionViewCellSelect = didCollectionViewCellSelect
            cell.frame = tableView.bounds
            cell.layoutIfNeeded()
            
            let tag = indexPath.section
            cell.collectionView.tag = tag
            tableViewCellCoordinator[tag] = indexPath
            cell.reloadData(title:gameInfo[indexPath.section][indexPath.row].title, images: gameInfo[indexPath.section][indexPath.row].images)
            cell.selectionStyle = .none
            return cell
    }
    

    
    
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showPipeGame" {
            let destVC = segue.destination as! PipeViewController
            destVC.currentLevel = pipeChooseLevel+1
            destVC.gameCharacter = pipeGamecharacter

        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Only support portrait orientation
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations:UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    


}

