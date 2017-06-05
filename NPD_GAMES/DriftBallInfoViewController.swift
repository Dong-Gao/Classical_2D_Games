//
//  DriftBallInfoViewController.swift
//  NPD_GAMES
//
//  Created by DongGao on 17/5/17.
//  Copyright © 2017 TheGreatMind. All rights reserved.
//

import UIKit

var driftChooseLevel: Int = -1
var driftLevelInfo = [[LevelInfo(title: "Choose Level of Drift Ball Game", images: ["drift_level1", "drift_level2","drift_level3", "drift_level4", "drift_level5"])]]

class DriftBallInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var myLevel: Int = 1
    fileprivate var tableViewCellCoordinator: [Int:IndexPath] = [:]
    
    @IBOutlet weak var bestLevel: UILabel!
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func startGame(_ sender: UIButton) {
        if driftChooseLevel == -1 {
            let alert = UIAlertController(title: "Choose the game level", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if (driftChooseLevel+1) > myLevel {
            let alert = UIAlertController(title: "Cannot", message: "You have to compelete the former level", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else {
            performSegue(withIdentifier: "showDriftBall", sender: self)
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
        
        let highestLevel = UserDefaults.standard.integer(forKey: gameUser.name + "driftLevel")
        if highestLevel > myLevel {
            myLevel = highestLevel
        }
        
        switch myLevel {
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        
        let highestLevel = UserDefaults.standard.integer(forKey: gameUser.name + "driftLevel")
        if highestLevel > myLevel {
            myLevel = highestLevel
        }
        bestLevel.text = "Your Best Level: \(myLevel)"
        
    }
    
    
    lazy var didCollectionViewCellSelect: (([Int]) -> Void)? = { (collectionViewCellIndex) in
        driftChooseLevel = collectionViewCellIndex[1]
        
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
            
            cell.reloadData(title:driftLevelInfo[indexPath.section][indexPath.row].title, images: driftLevelInfo[indexPath.section][indexPath.row].images)
            cell.selectionStyle = .none
            return cell
    }
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDriftBall" {
            let destVC = segue.destination as! DriftBallViewController
            destVC.currentLevel = driftChooseLevel+1
            
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
