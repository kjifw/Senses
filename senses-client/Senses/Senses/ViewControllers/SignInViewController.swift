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
        self.http?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signIn() {
        let username = self.username.text
        let password = self.password.text
        
        let bodyDict = [
            "username": username,
            "password": password
        ]
        
        let headers = [
            "Content-Type": "application/json"
        ]
        
        self.http?.post(toUrl: "\(self.url)/user/login", withBody: bodyDict, andHeaders: headers)
    }
    
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        if(identifier == "GoToPartyList") {
//            let username = self.username.text
//            let password = self.password.text
//            
//            if(username != nil && username != "" && password != nil && password != "") {
//                let alert = UIAlertController(title: "User data Error!",
//                                              message: "Username and/or password cannot be empty",
//                                              preferredStyle: .alert)
//                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
//                    (_) in
//                })
//                
//                alert.addAction(OKAction)
//                self.present(alert, animated: true, completion: nil)
//                return false
//            }
//        }
//        
//        return true
//    }
    
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
        let userCredentials = data as! Dictionary<String, Any>
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.username = userCredentials["username"] as! String?
        appDelegate.token = userCredentials["token"] as! String?
    }
    
    func didRecieveError(error: HttpError) {
//        print(error)
//        let alert = UIAlertController(title: "User data Error!",
//                                      message: "Username and/or password incorrect",
//                                      preferredStyle: .alert)
//        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
//            (_) in
//        })
//        
//        alert.addAction(OKAction)
//        self.present(alert, animated: true, completion: nil)
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


