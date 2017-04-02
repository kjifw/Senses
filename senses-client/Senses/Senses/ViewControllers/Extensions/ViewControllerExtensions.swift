//
//  ViewControllerExtensions.swift
//  Senses
//
//  Created by Jeff on 3/30/17.
//  Copyright © 2017 Telerik Academy. All rights reserved.
//

import UIKit

var loadingScreen = UIActivityIndicatorView()

extension UIViewController {
    
    func displayAlertMessage(withTitle title: String, andMessage message: String, andHandler handler: @escaping ((UIAlertAction) -> Void)) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: handler)
        
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadingScreenStart() {
        loadingScreen.frame = self.view.frame
        loadingScreen.activityIndicatorViewStyle = .whiteLarge
        loadingScreen.backgroundColor = .black
        
        self.view.addSubview(loadingScreen)
        loadingScreen.startAnimating()
    }
    
    func loadingScreenStop() {
        loadingScreen.stopAnimating()
        loadingScreen.removeFromSuperview()
    }
}
