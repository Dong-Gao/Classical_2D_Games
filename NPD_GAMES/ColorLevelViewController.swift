//
//  ColorLevelViewController.swift
//  NPD_GAMES
//
//  Created by DongGao on 15/5/17.
//  Copyright © 2017 TheGreatMind. All rights reserved.
//

import UIKit

class ColorLevelViewController: UIViewController {
    var myScore: Int = 0
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var start: UIButton!
    @IBAction func startGame(_ sender: UIButton) {
        performSegue(withIdentifier: "showColorGame", sender: self)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let bestScore =  UserDefaults.standard.integer(forKey: gameUser.name + "colorScore")
        if bestScore > myScore {
            myScore = bestScore
        }

        scoreLabel.text = "Your Highest Score is: \(bestScore)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
