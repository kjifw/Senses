//
//  RegisterViewController.swift
//  Senses
//
//  Created by Jeff on 3/27/17.
//  Copyright © 2017 Telerik Academy. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, HttpRequesterDelegate {
    
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
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var genderPreferences: UITextField!
    @IBOutlet weak var position: UITextField!
    
    @IBOutlet weak var usernameInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.http?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func register() {
        let alert = UIAlertController(title: "User Registered!",
                                      message: "User has been successfully registered",
                                      preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (_) in
            self.performSegue(withIdentifier: "unwindToSignIn", sender: self)
        })
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func didRecieveData(data: Any) {
        
    }
    
    func didRecieveError(error: HttpError) {
        
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
