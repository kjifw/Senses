//
//  AddPartyViewController.swift
//  Senses
//
//  Created by Jeff on 3/29/17.
//  Copyright © 2017 Telerik Academy. All rights reserved.
//

import UIKit
import CoreLocation

class AddPartyViewController: UIViewController, HttpRequesterDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    private var locationManger: CLLocationManager = CLLocationManager()
    
    private let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var sexPartyName: UITextField!
    @IBOutlet weak var startDateTime: UITextField!
    @IBOutlet weak var partyLocation: UITextField!
    @IBOutlet weak var partyType: UITextField!
    @IBOutlet weak var partyImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add sex party"
        
        self.http?.delegate = self
        
        self.imagePicker.delegate = self
        
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
                
                self.partyLocation.text = city
            }
        })
        
        self.locationManger.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.partyImage.contentMode = .scaleAspectFit
            self.partyImage.image = pickedImage
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImage() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func didRecieveData(data: Any) {
        DispatchQueue.main.async {
            let defaults = UserDefaults.standard
            let partyFullData = data as! Dictionary<String, Any>
            let partyData = partyFullData["party"] as! Dictionary<String, Any>
            
            if(partyData["uniqueId"] != nil) {
                defaults.set("\(partyData["uniqueId"]!)", forKey: "latestPartyHosted")
            }
            
            self.loadingScreenStop()
            self.displayAlertMessage(withTitle: "Party Created!", andMessage: "Party was successfully created!", andHandler: {
                (_) in
                self.performSegue(withIdentifier: "unwindToMenuController", sender: self)
            })
        }
    }
    
    @IBAction func createParty() {
        let sexPartyName =  self.sexPartyName.text
        let sexPartyLocation = self.partyLocation.text
        let sexPartyStarts = self.startDateTime.text
        let sexPartyType = self.partyType.text
        
        let defaults = UserDefaults.standard
        let sexPartyHost = defaults.string(forKey: "username")!
        
        let myImage = self.partyImage.image
        let imageData = UIImageJPEGRepresentation(myImage!, 0.8)
        let base64Str = imageData?.base64EncodedString(options: .endLineWithCarriageReturn)
        
        let bodyDict = [
            "name": sexPartyName,
            "location": sexPartyLocation,
            "startDateTime": sexPartyStarts,
            "host": sexPartyHost,
            "partyType": sexPartyType,
            "image": base64Str
        ]
        
        let headers = [
            "Content-Type": "application/json"
        ]
        
        self.loadingScreenStart()
        self.http?.post(toUrl: "\(self.url)/party/create", withBody: bodyDict, andHeaders: headers)
    }
}
