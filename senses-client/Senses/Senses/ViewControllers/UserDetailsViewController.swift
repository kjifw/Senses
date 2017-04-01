//
//  UserDetailsViewController.swift
//  Senses
//
//  Created by Jeff on 4/1/17.
//  Copyright © 2017 Telerik Academy. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController, HttpRequesterDelegate {
    
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
    
    var userUsername: String?
    var user: UserDetailsModel?
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var kudos: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var genderPreferences: UILabel!
    @IBOutlet weak var about: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.http?.delegate = self
        
        let bodyDict = [
            "requiredUsername": self.userUsername!
        ]
        
        let headers = [
            "Content-Type": "application/json"
        ]
        
        self.loadingScreenStart()
        self.http?.post(toUrl: "\(self.url)/user/profile", withBody: bodyDict, andHeaders: headers)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    @IBAction func addKudos() {
    }
    
    @IBAction func inviteToParty() {
    }
    
    func didRecieveData(data: Any) {
        DispatchQueue.main.async {
            let userInformation = data as! Dictionary<String, Any>
            let userModel = UserDetailsModel.init(withDict: userInformation)
            var allPrefs = ""
            
            self.username.text = userModel.username
            self.city.text = userModel.city
            self.age.text = userModel.age
            self.gender.text = userModel.gender
            self.kudos.text = userModel.kudos
            
            userModel.genderPrefs?.forEach({ (item) in
                allPrefs += "\(item)"
            })
            
            self.genderPreferences.text = allPrefs
            self.about.text = userModel.about
            
            self.loadingScreenStop()
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
