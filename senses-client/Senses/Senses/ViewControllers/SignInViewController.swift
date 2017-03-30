//
//  ViewController.swift
//  Senses
//
//  Created by Jeff on 3/25/17.
//  Copyright © 2017 Telerik Academy. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, HttpRequesterDelegate {
    
    var url: String {
        get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.baseUrl
        }
    }
    
    var http: HttpRequester? {
        get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.http
        }
    }
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.http?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signIn() {
        let username = self.username.text
        let password = self.password.text
        
        if(username == nil || username == "" || password == nil || password == "") {
            self.displayAlertMessage(withTitle: "Fileds Error", andMessage: "All fields must be filled.", andHandler: {
            (_) in
            })
        } else {
            let bodyDict = [
                "username": username,
                "password": password
            ]
            
            let headers = [
                "Content-Type": "application/json"
            ]
            
            self.http?.post(toUrl: "\(self.url)/user/login", withBody: bodyDict, andHeaders: headers)
        }
    }
    
    func didRecieveData(data: Any) {
        //     let nav = self.navigationController
        //     if (nav != nil) {
        //            var stack = nav?.viewControllers
        //
        //            print(stack?.count as Any)
        //
        //            stack?.remove(at: 0)
        //
        //            nav?.setViewControllers(stack!, animated: false)
        DispatchQueue.main.async {
        let userCredentials = data as! Dictionary<String, Any>
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.username = userCredentials["username"] as! String?
        appDelegate.token = userCredentials["token"] as! String?
        
        self.displayAlertMessage(withTitle: "Login Successfull", andMessage: "All user data valid. Enjoy.", andHandler: {
            (_) in
                self.performSegue(withIdentifier: "GoToPartyList", sender: self)
            })
        }
    }
    
    func didRecieveError(error: HttpError) {
        DispatchQueue.main.async {
            self.displayAlertMessage(withTitle: "Login Unsuccessfull", andMessage: "Invalid username or password.", andHandler: {
                (_) in
            })
        }
    }
    
    @IBAction func returnToSignInViewController(segue: UIStoryboardSegue) {
    }
    
    //     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if(segue.identifier == "GoToPartyList") {
    //            let nextVC = segue.destination as! PartyListTableViewController
    //            nextVC.data = self.data
    //        }
    //     }
}


