//
//  RegisterViewController.swift
//  Senses
//
//  Created by Jeff on 3/27/17.
//  Copyright © 2017 Telerik Academy. All rights reserved.
//

import UIKit
import CoreLocation

class RegisterViewController: UIViewController, HttpRequesterDelegate, CLLocationManagerDelegate {
    
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
    @IBOutlet weak var aboutMe: UITextField!
    @IBOutlet weak var city: UITextField!
    
    private var locationManger: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Register"
        
        self.http?.delegate = self
        
        self.locationManger.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManger.delegate = self
        self.locationManger.requestWhenInUseAuthorization()
        self.locationManger.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation: CLLocation = locations[locations.count - 1]
        
        let geocoder: CLGeocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(latestLocation, completionHandler: {
            (placemarks, error) in
            
            if(error == nil && (placemarks?.count)! > 0) {
                let last = placemarks?.last
                let city: String = "\(last!.addressDictionary!["City"]!)"
                
                self.city.text = city
            }
        })
        
        self.locationManger.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
    
    @IBAction func register() {
        let username = self.username.text
        let email = self.email.text
        let password = self.password.text
        let age = self.age.text
        let gender = self.gender.text
        let genderPreferences = self.genderPreferences.text
        let about = self.aboutMe.text
        let city = self.city.text
        
        let bodyDict = [
            "username": username,
            "email": email,
            "password": password,
            "age": age,
            "gender": gender,
            "genderPreferences": genderPreferences,
            "about": about,
            "city": city
        ]
        
        let headers = [
            "Content-Type": "application/json"
        ]
        
        if (self.areFieldsValid()) {
            self.loadingScreenStart()
            self.http?.post(toUrl: "\(self.url)/user/register", withBody: bodyDict, andHeaders: headers)
        }
    }
    
    private func areFieldsValid() -> Bool {
        let username = self.username.text
        let email = self.email.text
        let password = self.password.text
        let repeatPassword = self.repeatPassword.text
        let age = self.age.text
        let gender = self.gender.text
        let genderPreferences = self.genderPreferences.text
        let city = self.city.text
        
        if (username?.isEmpty)! {
            self.displayAlertMessage(withTitle: "Username", andMessage: "Username cannot be empty", andHandler: {
                (_) in
            })
            return false
        } else if (email?.isEmpty)! {
            self.displayAlertMessage(withTitle: "Email", andMessage: "Email cannot be empty", andHandler: {
                (_) in
            })
            return false
        } else if (password?.isEmpty)! {
            self.displayAlertMessage(withTitle: "Password", andMessage: "Password cannot be empty", andHandler: {
                (_) in
            })
            return false
        } else if (repeatPassword?.isEmpty)! {
            self.displayAlertMessage(withTitle: "Repeat Password", andMessage: "Repead password cannot be empty", andHandler: {
                (_) in
            })
            return false
        } else if (password != repeatPassword) {
            self.displayAlertMessage(withTitle: "Password", andMessage: "Password and repeat password must match", andHandler: {
                (_) in
            })
            return false
        } else if (age?.isEmpty)! {
            self.displayAlertMessage(withTitle: "Age", andMessage: "Age cannot be empty", andHandler: {
                (_) in
            })
            return false
        } else if (gender?.isEmpty)! {
            self.displayAlertMessage(withTitle: "Gender", andMessage: "Gender cannot be empty", andHandler: {
                (_) in
            })
            return false
        } else if (genderPreferences?.isEmpty)! {
            self.displayAlertMessage(withTitle: "Gender Preferences", andMessage: "Gender preferences cannot be empty", andHandler: {
                (_) in
            })
            return false
        } else if (city?.isEmpty)! {
            self.displayAlertMessage(withTitle: "City", andMessage: "City cannot be empty", andHandler: {
                (_) in
            })
            return false
        }
        
        return true
    }
    
    func didRecieveData(data: Any) {
        DispatchQueue.main.async {
            self.loadingScreenStop()
            self.displayAlertMessage(withTitle: "Registration Successfull", andMessage: "All user data valid. You can login now.", andHandler: {
                (_) in
                self.performSegue(withIdentifier: "unwindToSignIn", sender: self)
            })
        }
    }
    
    func didRecieveError(error: HttpError) {
        DispatchQueue.main.async {
            self.loadingScreenStop()
            self.displayAlertMessage(withTitle: "Registration unsuccessfull", andMessage: "User already exists.", andHandler: {
                (_) in
            })
        }
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
