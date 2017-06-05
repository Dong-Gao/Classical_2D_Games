//
//  ProfileTableViewController.swift
//  NPD_GAMES
//
//  Created by DongGao on 23/5/17.
//  Copyright © 2017 TheGreatMind. All rights reserved.
//

import UIKit
import SafariServices

class ProfileTableViewController: UITableViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    var sectionTitle = ["Personal Information","About the Game","About the Authors","More Options"]
    var sectionContent = [["","","","",""],["Github","Video Demonstration"],["Author: Dong Gao","Supervisor: Prof. Richard Sinnott"],["Log Out"]]
    
    var links = ["https://www.xiaoboswift.com","https://www.blog.xiaoboswift.com"]
    
    @IBAction func choosePhoto(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        sectionContent[0][0] = "Username: " + gameUser.name
        sectionContent[0][1] = "Name: " + gameUser.username
        sectionContent[0][2] = "Age: " + String(gameUser.age)
        sectionContent[0][3] = "PID: " + String(gameUser.pid)
        sectionContent[0][4] = "Email: " + gameUser.email

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 5
        case 1:
            return 2
        case 2:
            return 2
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    override  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = sectionContent[indexPath.section][indexPath.row]
        if indexPath.section == 1 {
            cell.accessoryType = .disclosureIndicator
        }
        if indexPath.section == 3 {
            cell.textLabel?.textAlignment = .center
        }
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        switch indexPath.section {
        case 1:
            if let url = URL(string: links[indexPath.row]) {
                let sfVc = SFSafariViewController(url: url)
                present(sfVc, animated: true, completion: nil)
            } else {
                performSegue(withIdentifier: "showWebView", sender: self)
            }
        case 3:
            if indexPath.row == 0 {
                let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
                let goMainView  = UIAlertAction(title: "Log out", style: .destructive, handler: { action in self.performSegue(withIdentifier: "BackToRegister", sender: self)})
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alert.addAction(goMainView)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
            
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.font = UIFont(name: "Avenir-Book", size: 16)
        switch indexPath.section {
        case 3:
            if indexPath.row == 0 {
                cell.textLabel?.font = UIFont(name: "Avenir-Medium", size: 16)
                cell.textLabel?.textColor = UIColor.red
            }
        default:
            break

        }
    }
    
    

    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 224/255, green: 227/255, blue: 218/255, alpha: 1)
        header.textLabel?.font = UIFont(name: "Verdana", size: 13)
        header.textLabel?.textAlignment = .center
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        coverImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.layer.cornerRadius = coverImageView.frame.size.width/2
        
        coverImageView.clipsToBounds = true
        
        // Add constrains to the chosen image
        let coverWidthCons = NSLayoutConstraint(item: coverImageView, attribute: .width, relatedBy: .equal, toItem: coverImageView, attribute: .width, multiplier: 1, constant: 0)
        
        let coverHeightCons = NSLayoutConstraint(item: coverImageView, attribute: .height, relatedBy: .equal, toItem: coverImageView, attribute: .height, multiplier: 1, constant: 0)
        
        coverWidthCons.isActive = true
        coverHeightCons.isActive = true
        
        
        dismiss(animated: true, completion: nil)
    }
    

}
