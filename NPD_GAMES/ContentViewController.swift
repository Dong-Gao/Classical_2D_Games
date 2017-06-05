//
//  ContentViewController.swift
//  NPD_GAMES
//
//  Created by DongGao on 12/5/17.
//  Copyright © 2017 TheGreatMind. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet weak var labelHeading: UILabel!
    @IBOutlet weak var labelFooter: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnDone: UIButton!
    @IBAction func btnDoneTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "guideShow")
    }
    
    
    
    var index = 0
    var heading = ""
    var footer = ""
    var imageName = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelHeading.text = heading
        labelFooter.text = footer
        imageView.image = UIImage(named: imageName)
        pageControl.currentPage = index
        btnDone.isHidden = (index != 2)

        // Do any additional setup after loading the view.
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
