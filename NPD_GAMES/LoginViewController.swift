//
//  LoginViewController.swift
//  NPD_GAMES
//
//  Created by DongGao on 16/5/17.
//  Copyright © 2017 TheGreatMind. All rights reserved.

//  This class is used to login in the app

import UIKit

class LoginViewController: UIViewController, NSURLConnectionDelegate {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var register: UIButton!
    
    
    @IBAction func signIn(_ sender: UIButton) {
        if userName.text == nil || (userName.text?.isEmpty)! {
            let alert = UIAlertController(title: "Error", message: "Empty UserName", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        if passWord.text == nil || (passWord.text?.isEmpty)! {
            let alert = UIAlertController(title: "Error", message: "Empty PassWord", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        let username = userName.text!
        let password = passWord.text!
        gameUser.name = username
        gameUser.password = password
        
        dbConnect.loginIn(username, password) { (results) in
            if results["allow"] as! String == "yes" {
                DispatchQueue.main.sync {
                    gameUser.pid  = Int(results["pid"] as! String )!
                    gameUser.age  = Int(results["age"] as! String )!
                    gameUser.email  = results["email"] as! String
                    gameUser.username = results["real_name"] as! String
                    
                    let alert = UIAlertController(title: "Login Successfully!", message: "Welcome to NPD GAMES!", preferredStyle: .alert)
                    let goMainView  = UIAlertAction(title: "OK", style: .default, handler: { action in self.performSegue(withIdentifier: "segueToMainView", sender: self)})
                    alert.addAction(goMainView)
                    self.present(alert, animated: true, completion: nil)

                    
                }

            }else {
                
                DispatchQueue.main.sync {
                    let alert = UIAlertController(title: "Error", message: "Error Username or Password", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                    
                    
                }

                

                
            }

    }
    
}
    

    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        signIn.layer.cornerRadius = 5
        signIn.layer.borderWidth = 2
        register.layer.cornerRadius = 5
        register.layer.borderColor = UIColor(red: 46/255, green: 196/255, blue: 182/255, alpha: 1).cgColor
        register.layer.borderWidth = 2
        
        // Add a seperate line
        let border = CALayer()
        let width = CGFloat(1)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: userName.frame.size.height, width:  userName.frame.size.width, height: 0.5)
        border.borderWidth = width
        userName.superview?.layer.addSublayer(border)
        userName.layer.masksToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
