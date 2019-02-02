//
//  ViewController.swift
//  DATN_PHUC4
//
//  Created by Tran Anh Quang on 12/21/18.
//  Copyright © 2018 Tran Anh Quang. All rights reserved.
//

import UIKit
var Token : String = ""

class ViewController: UIViewController, UITextFieldDelegate {

    var loginTimer : Timer!

    @IBOutlet weak var status_login: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var usernametxt: UITextField!
    @IBOutlet weak var passwordtxt: UITextField!
//    var Token : String = ""
    var message : String = ""
    var Result : Bool = false
    var url_api_login : String = "https://phucproject.pythonanywhere.com/api/auth/sign-in/"
    // SIGNIN
    struct signin : Decodable{
        
        let message : String
        let data : [Data]
        let result : Bool
        
    }
    struct Data : Decodable{
        
        let username : String
        let token : String
        
    }
    // ADD device
    struct add : Decodable{
        let message : String
        var data : [ADD_data]
        let result : Bool

    }

    struct ADD_data : Decodable{

        let field : String
        let message : String

    }
    
    
    @IBAction func loginbnt(_ sender: Any) {
        performSegue(withIdentifier: "toward", sender: nil)

//        loginfn()
        
    }
    
    
    func loginfn(){
        
        if((usernametxt.text != "")&&(passwordtxt.text != "")){
            // clear status
            status_login.text = ""
            // run wait button
            activity.isHidden = false
            activity.startAnimating()
            // start timer every 2 second for plashing
            loginTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.plash), userInfo: nil, repeats: true)
            // request http username password
            connect_login(Username: usernametxt.text!, Password: passwordtxt.text!, Url: url_api_login)

        }
        else{
            
            status_login.text = "Please enter your account again"
        }
        
        
    }
    
    @objc func plash(){
        if(Result){
            activity.isHidden = true
            activity.stopAnimating()
            performSegue(withIdentifier: "toward", sender: nil)
            loginTimer.invalidate()
            Result = false
        }
        else{
            activity.isHidden = true
            activity.stopAnimating()
            status_login.text = "Your password or username is wrong, try it again"
            loginTimer.invalidate()
        }
    }
    func connect_login(Username : String, Password : String, Url : String){
        let parameters = ["username": Username, "password": Password]
        
        guard let url = URL(string: Url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            //            if let response = response {
            //                print(response)
            //            }
            
            if let data = data {
                do {
                    //                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                    //                        print(json)
                    let Json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                    
                    if(Json!["result"] as! Bool){
                        let json = try JSONDecoder().decode(signin.self, from: data)
                        self.Result = json.result
                        Token = json.data[0].token
                        
                        print(json.data.count)
                        
                        print("true")
                    }
                    else{
                        
                        self.Result = false
                        print("false")
                    }
                    
                   
                   
                } catch {
                    print(error)
                }
            }
            }.resume()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        self.usernametxt.delegate = self
        self.passwordtxt.delegate = self
        activity.isHidden = true
        
        print("Hi")
        // Test
        
    
        // Do any additional setup after loading the view, typically from a nib.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }

    func connectToWebAPI(){
        
        
        let parameters = ["username": "quang123", "password": "admin123"]
        
        guard let url = URL(string: "https://phucproject.pythonanywhere.com/api/auth/sign-in/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
//            if let response = response {
//                print(response)
//            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
//                    let json = try JSONDecoder().decode(signin.self, from: data)
                    
                } catch {
                    print(error)
                }
            }
            }.resume()
    }
    func connectToWebAPI_token(){
        let parameters = ["unit": "m3/s", "serial": "dv1122334411756", "name": "Quạt1"]
        guard let url = URL(string: "https://phucproject.pythonanywhere.com/api/device/add/") else { return }
        var request = URLRequest(url: url)
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Token \(Token)", forHTTPHeaderField: "Authorization")

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            //            if let response = response {
            //                print(response)
            //            }
            if let data = data {
                do {
//            let json = try JSONSerialization.jsonObject(with: data, options: [])
//                                        print(json)
                   let json = try JSONDecoder().decode(add.self, from: data)
                        print(json.result)
                    
                    self.message = json.message
                   
                }  catch {
                    print(error)
                }
            }
            }.resume()
//        self.performSegue(withIdentifier: "toward", sender: nil)

//        if(message == "Error!!!"){
//            print("OK")
//            self.performSegue(withIdentifier: "toward", sender: nil)
//        }
    }
    
    
    

}

