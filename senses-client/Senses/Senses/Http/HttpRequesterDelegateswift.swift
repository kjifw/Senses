//
//  HttpRequesterDelegateswift.swift
//  Senses
//
//  Created by Jeff on 3/27/17.
//  Copyright © 2017 Telerik Academy. All rights reserved.
//

import UIKit

protocol HttpRequesterDelegate {
 
    func didRecieveData(data: Any)
    
    func didRecieveError(error: HttpError)
}

extension HttpRequesterDelegate {
    
    func didRecieveData(data: Any) {
        
    }
    
    func didRecieveError(error: HttpError) {
        
    }
}
