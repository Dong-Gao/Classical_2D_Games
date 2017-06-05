//
//  StatisticsTableViewController.swift
//  NPD_GAMES
//
//  Created by DongGao on 23/5/17.
//  Copyright © 2017 TheGreatMind. All rights reserved.
//

import UIKit

class StatisticsTableViewController: UITableViewController {
    
    var gameImages = ["pipe_game_stat","drift_ball_stat","card_memory_stat","break_out_stat","color_game_stat","balloon_stat",]
    var gameNames = ["Pipe","DriftBall","Card","Break Out","Color","Balloon"]
    var mgid:Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        // Configure the cell...
       cell.gameImage.image = UIImage(named: gameImages[indexPath.row])
       cell.gameImage.layer.cornerRadius = cell.gameImage.frame.size.width/2
       cell.gameImage.clipsToBounds = true
       cell.gameName.text = gameNames[indexPath.row]

        return cell
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Set custom row height
        return 120.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mgid = indexPath.row + 1
        performSegue(withIdentifier: "ShowStatistics", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowStatistics" {
            gameUser.gid = mgid
        }
    }
    

}
