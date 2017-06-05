//
//  BalloonLevelViewController.swift
//  NPD_GAMES
//
//  Created by DongGao on 17/5/17.
//  Copyright © 2017 TheGreatMind. All rights reserved.
//

import UIKit

var balloonChooseLevel: Int = -1
var balloonLevelInfo = [[LevelInfo(title: "Choose Level of Balloon Game", images: ["balloon_level1", "balloon_level2","balloon_level3", "balloon_level4", "balloon_level5", "balloon_level6"])]]

class BalloonLevelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var myLevel: Int = 1
    // This variable is used to store the coordinate of the selected collection view
    fileprivate var tableViewCellCoordinator: [Int:IndexPath] = [:]
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var start: UIButton!
    
    @IBAction func startGame(_ sender: UIButton) {
        if balloonChooseLevel == -1 {
            let alert = UIAlertController(title: "Choose the game level", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if (balloonChooseLevel+1) > myLevel {
            let alert = UIAlertController(title: "Cannot", message: "You have to compelete the former level", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else {
            performSegue(withIdentifier: "showBalloonGame", sender: self)
        }

        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.separatorStyle = .none
        
        self.tableView!.register(UINib(nibName:"OneTableViewCell", bundle:nil), forCellReuseIdentifier:"oneCell")
        self.tableView!.estimatedRowHeight = 300.0
        self.tableView!.rowHeight = UITableViewAutomaticDimension
        
        let bestLevel = UserDefaults.standard.integer(forKey: gameUser.name+"balloon")
        if bestLevel > myLevel {
            myLevel = bestLevel
            
        }
        switch myLevel {
        case 1:
            balloonLevelInfo = [[LevelInfo(title: "Choose Level of Balloon Game", images: ["balloon_level1", "balloon_level2_lock","balloon_level3_lock", "balloon_level4_lock", "balloon_level5_lock", "balloon_level6_lock"])]]
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
    
    override func viewDidAppear(_ animated: Bool) {
        // To refresh the data every time the view is loaded
        tableView.reloadData()
        let bestLevel = UserDefaults.standard.integer(forKey: gameUser.name+"balloon")
        if bestLevel > myLevel {
            myLevel = bestLevel
        }
        
        levelLabel.text = "Your Best Level is: \(myLevel)"
        

    }

    
    
    lazy var didCollectionViewCellSelect: (([Int]) -> Void)? = { (collectionViewCellIndex) in
        balloonChooseLevel = collectionViewCellIndex[1]
        
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
            
            cell.reloadData(title:balloonLevelInfo[indexPath.section][indexPath.row].title, images: balloonLevelInfo[indexPath.section][indexPath.row].images)
            cell.selectionStyle = .none
            return cell
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showBalloonGame" {
            let destVC = segue.destination as! BalloonGameViewController
            destVC.currentLevel = balloonChooseLevel+1
        }

        
    }

}
