//
//  RegisterViewController.swift
//  NPD_GAMES
//
//  Created by DongGao on 17/5/17.
//  Copyright © 2017 TheGreatMind. All rights reserved.

//  This class is used to register a new player

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var login: UIButton!
    

    @IBAction func registerUser(_ sender: UIButton) {

        if email.text == nil || (email.text?.isEmpty)! {
            let alert = UIAlertController(title: "Error", message: "Empty Email", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        if username.text == nil || (username.text?.isEmpty)! {
            let alert = UIAlertController(title: "Error", message: "Empty Username", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        
        if password.text == nil || (password.text?.isEmpty)! {
            let alert = UIAlertController(title: "Error", message: "Empty Password", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        
        if name.text == nil || (name.text?.isEmpty)! {
            let alert = UIAlertController(title: "Error", message: "Empty Name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        
        if age.text == nil || (age.text?.isEmpty)! {
            let alert = UIAlertController(title: "Error", message: "Empty Age", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        
        let ema = email.text!
        let realname = name.text!
        let uage = Int(age.text!)!
        let uname = username.text!
        let pass = password.text!
        
        dbConnect.registerUser(ema, realname, uage, uname, pass) { (results) in

            if results["Allow"] as! String == "yes" {
                // This method uses callback to make sure only after receving the response from sever, then carry out next steps
                DispatchQueue.main.sync {
                    let alert = UIAlertController(title: "Register Successfully!", message: "Login Now!", preferredStyle: .alert)
                    let goLogin  = UIAlertAction(title: "OK", style: .default, handler: { action in self.performSegue(withIdentifier: "segueToLogin", sender: self)})
                    alert.addAction(goLogin)
                    self.present(alert, animated: true, completion: nil)

                }
                
            } else {
                DispatchQueue.main.sync {
                    let alert = UIAlertController(title: "Already Registered!", message: "Login Now!", preferredStyle: .alert)
                    let goLogin  = UIAlertAction(title: "OK", style: .default, handler: { action in self.performSegue(withIdentifier: "segueToLogin", sender: self)})
                    alert.addAction(goLogin)
                    self.present(alert, animated: true, completion: nil)
                    
                }

                
            }
            
        }
        
    }
    
    // Segue to the login viewcontroller
    @IBAction func goLogin(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToLogin", sender: sender)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register.layer.cornerRadius = 5
        login.layer.cornerRadius = 5
        login.layer.borderColor = UIColor(red: 46/255, green: 196/255, blue: 182/255, alpha: 1).cgColor
        login.layer.borderWidth = 2
        
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
