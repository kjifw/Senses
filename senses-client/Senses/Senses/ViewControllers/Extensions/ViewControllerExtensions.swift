//
//  ViewControllerExtensions.swift
//  Senses
//
//  Created by Jeff on 3/30/17.
//  Copyright © 2017 Telerik Academy. All rights reserved.
//

import UIKit

extension UIViewController {
    func displayAlertMessage(withTitle title: String, andMessage message: String, andHandler handler: @escaping ((UIAlertAction) -> Void)) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: handler)
        
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
}
