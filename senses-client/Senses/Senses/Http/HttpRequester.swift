//
//  HttpRequester.swift
//  Senses
//
//  Created by Jeff on 3/27/17.
//  Copyright © 2017 Telerik Academy. All rights reserved.
//

import UIKit

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

enum HttpError: Error {
    case api(String)
}

class HttpRequester {
    var delegate: HttpRequesterDelegate?
    
    func send(withMethod method: HttpMethod,
              toUrl urlString: String,
              withBody bodyDict: Dictionary<String, Any>? = nil,
              andHeaders headers: Dictionary<String, String> = [:]) {
        
        let url = URL(string: urlString)
        
        var request = URLRequest(url: url!)
        request.httpMethod = method.rawValue
        
        if(bodyDict != nil) {
            do {
                let body = try JSONSerialization.data(withJSONObject: bodyDict!, options: .prettyPrinted)
                request.httpBody = body
            } catch {
            }
        }
        
        headers.forEach({ item in
            request.setValue(item.value, forHTTPHeaderField: item.key)
        })
        
        weak var weakSelf = self
        
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: {
            bodyData, response, error in
            do {
                let body = try JSONSerialization.jsonObject(with: bodyData!, options: .allowFragments)
                
                if((response as! HTTPURLResponse).statusCode >= 400) {
                    weakSelf?.delegate?.didRecieveError(error: .api("error"))
                    return
                }
                
                weakSelf?.delegate?.didRecieveData(data: body)
                
            } catch {
                weakSelf?.delegate?.didRecieveError(error: .api(error.localizedDescription))
            }
        })
        
        dataTask.resume()
    }
    
    func get(fromUrl urlString: String, andHeaders headers: Dictionary<String, String> = [:]){
        self.send(withMethod: .get, toUrl: urlString, withBody: nil, andHeaders: headers)
    }
    
    func post(toUrl urlString: String, withBody bodyDict: Dictionary<String, Any>, andHeaders headers: Dictionary<String, String>) {
        self.send(withMethod: .post, toUrl: urlString, withBody: bodyDict, andHeaders: headers)
    }
    
    func put(toUrl urlString: String, withBody bodyDict: Dictionary<String, Any>, andHeaders headers: Dictionary<String, String>) {
        self.send(withMethod: .put, toUrl: urlString, withBody: bodyDict, andHeaders: headers)
    }
}



































