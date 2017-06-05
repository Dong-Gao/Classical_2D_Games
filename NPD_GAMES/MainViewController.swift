//
//  MainViewController.swift
//  NPD_GAMES
//
//  Created by DongGao on 11/5/17.
//  Copyright © 2017 TheGreatMind. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "All Games", style: .plain, target: nil, action: nil)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // This is used to show guidence when the app is firstly lunched
//        let defaults = UserDefaults.standard
//        if defaults.bool(forKey: "guideShow") {
//            return
//        }
// 
//        if let pageVC = storyboard?.instantiateViewController(withIdentifier: "GuideController") as? GuiderPageViewController {
//            present(pageVC, animated: true, completion: nil)
//        }
    }

}
