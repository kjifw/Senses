//
//  AddPartyViewController.swift
//  Senses
//
//  Created by Jeff on 3/29/17.
//  Copyright © 2017 Telerik Academy. All rights reserved.
//

import UIKit

class AddPartyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createParty() {
        let alert = UIAlertController(title: "Party created!",
                                      message: "You have successfully created a party!",
                                      preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (_) in
            self.performSegue(withIdentifier: "unwindToMenuController", sender: self)
        })
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
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
