//
//  WebViewController.swift
//  NPD_GAMES
//
//  Created by DongGao on 5/6/17.
//  Copyright © 2017 TheGreatMind. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        webView.isHidden = true
        let wkWebView = WKWebView(frame: view.frame)
        wkWebView.autoresizingMask = [.flexibleHeight]
        view.addSubview(wkWebView)
        //使用WKWebView方法载入网页
        if let url = URL(string: "http://115.146.93.249:8080/NPDSERVER/") {
            let request = URLRequest(url: url)
            wkWebView.load(request)
        }

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
