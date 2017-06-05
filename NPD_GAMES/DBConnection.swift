//
//  DBConnection.swift
//  NPD_GAMES
//
//  Created by DongGao on 15/5/17.
//  Copyright © 2017 TheGreatMind. All rights reserved.

//  This class is used to connect with cloud sever by using RESTful API and Basic Authentication

import Foundation

var gameUser = User()
var dbConnect = DBConnection()

class DBConnection {

    //  This method is used to log in the app
    func loginIn(_ username: String, _ password: String, completionHandler: @escaping ([String: AnyObject]) -> ()) {
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        let todoEndpoint: String = "http://115.146.93.249:8080/NPDSERVER/rest/npdpatients/login"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        // Set up the session
        let session = URLSession.shared
        var resultsArray:[String: AnyObject]!
        // Make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // Check for any errors
            guard error == nil else {
                resultsArray = ["allow": "no" as AnyObject]
                completionHandler(resultsArray)
                print("error calling GET on /todos/1")
                return
            }
            // Make sure we got data
            guard let responseData = data else {
                resultsArray = ["allow": "no" as AnyObject]
                completionHandler(resultsArray)
                print("Error: did not receive data")
                return
            }
            // Parse the result as JSON, since that's what the API provides
            do {
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                    resultsArray = ["allow": "no" as AnyObject]
                    completionHandler(resultsArray)
                    print("error trying to convert data to JSON1111")
                    return
                }
                resultsArray = todo
                completionHandler(resultsArray)
                return
            } catch  {
                resultsArray = ["allow": "no" as AnyObject]
                completionHandler(resultsArray)
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
     }
    
    //  This method is used to register the app
    func registerUser(_ email: String, _ name: String, _ age: Int, _ username: String, _ password: String, completionHandler: @escaping ([String: AnyObject]) -> ()) {
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
    
        let todoEndpoint: String = "http://115.146.93.249:8080/NPDSERVER/rest/npdpatients/newpatient/\(name)/\(age)/\(email)"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        // Set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        var resultsArray:[String: AnyObject]!
        // Make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // Check for any errors
            guard error == nil else {
                resultsArray = ["Allow": "no" as AnyObject]
                completionHandler(resultsArray)
                return
            }
            // Make sure we got data
            guard let responseData = data else {
                resultsArray = ["Allow": "no" as AnyObject]
                completionHandler(resultsArray)
                print("Error: did not receive data")
                return
            }
            // Parse the result as JSON, since that's what the API provides
            do {
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                    resultsArray = ["Allow": "no" as AnyObject]
                    completionHandler(resultsArray)
                    print("error trying to convert data to JSON")
                    return
                }
                print("The todo is: " + todo.description)
                
                resultsArray = todo
                completionHandler(resultsArray)
                return

            } catch  {
                resultsArray = ["Allow": "no" as AnyObject]
                completionHandler(resultsArray)
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    
    
    //  This method is used to get the game record for each player from the server
    func findLevelRecord(_ level: Int,_ gid: Int, completionHandler: @escaping ([[String: AnyObject]]) -> ()) {
        let uname = gameUser.name
        let password = gameUser.password
        let pid = gameUser.pid
        
        let loginString = String(format: "%@:%@", uname, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        let todoEndpoint: String = "http://115.146.93.249:8080/NPDSERVER/rest/npdpatients/patients/\(pid)/perlevel/\(level)/\(gid)"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        // Set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        var resultsArray:[[String: AnyObject]]!
        // Make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // Check for any errors
            guard error == nil else {
                resultsArray = [["Allow": "no" as AnyObject]]
                completionHandler(resultsArray)
                return
            }
            // Make sure we got data
            guard let responseData = data else {
                resultsArray = [["Allow": "no" as AnyObject]]
                completionHandler(resultsArray)
                print("Error: did not receive data")
                return
            }
            // Parse the result as JSON, since that's what the API provides
            do {
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String: AnyObject]] else {
                    resultsArray = [["Allow": "no" as AnyObject]]
                    completionHandler(resultsArray)
                    print("error trying to convert data to JSON222222")
                    return
                }
                // now we have the todo, let's just print it to prove we can access it
                print("Find level record: " + todo.description)
                
                resultsArray = todo
                completionHandler(resultsArray)
                return
                
            } catch  {
                resultsArray = [["Allow": "no" as AnyObject]]
                completionHandler(resultsArray)
                print("error trying to convert data to JSON333333")
                return
            }
        }
        task.resume()
        
    }

    //  This method is used to get the highest score of all player
    func findMaxRecord(_ gid: Int, completionHandler: @escaping ([[String: AnyObject]]) -> ()) {
        let uname = gameUser.name
        let password = gameUser.password
        let pid = gameUser.pid
        
        let loginString = String(format: "%@:%@", uname, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        let todoEndpoint: String = "http://115.146.93.249:8080/NPDSERVER/rest/npdpatients/patients/\(pid)/maxscore/\(gid)"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        var resultsArray:[[String: AnyObject]]!
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                resultsArray = [["Allow": "no" as AnyObject]]
                completionHandler(resultsArray)

                return
            }
            // make sure we got data
            guard let responseData = data else {
                resultsArray = [["Allow": "no" as AnyObject]]
                completionHandler(resultsArray)
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String: AnyObject]] else {
                    resultsArray = [["Allow": "no" as AnyObject]]
                    completionHandler(resultsArray)
                    print("error trying to convert data to JSON222222")
                    return
                }
                // now we have the todo, let's just print it to prove we can access it
                print("The todo is: " + todo.description)
                
                resultsArray = todo
                completionHandler(resultsArray)
                return
                
            } catch  {
                resultsArray = [["Allow": "no" as AnyObject]]
                completionHandler(resultsArray)
                print("error trying to convert data to JSON333333")
                return
            }
        }
        task.resume()
        
    }


    
    //  This method is used to upload the game record to could server
    func insertGameRecord(_ gameInfo: GameInfo) {
        // get current time
        let currentdate = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let dateString = dateformatter.string(from: currentdate)
        
        let uname = gameUser.name
        let password = gameUser.password
        let pid = gameUser.pid
        let loginString = String(format: "%@:%@", uname, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        
        let todoEndpoint: String = "http://115.146.93.249:8080/NPDSERVER/rest/npdpatients/patients/newrecord/\(gameInfo.gid!)/\(gameInfo.score!)/\(gameInfo.level!)/\(pid)/\(dateString)/\(gameInfo.percentage!)"
        
        print("Test Insert Data")
        print(todoEndpoint)
        let url = URL(string:todoEndpoint.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                return
            }
        }
        task.resume()
        
    }
    
}
