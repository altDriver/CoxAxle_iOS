//
//  Reachability.swift
//  CoxAxle
//
//  Created by Prudhvi on 21/07/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//



import Foundation
import SystemConfiguration

open class Reachability {
    
    //MARK:- CHECKING INTERNET CONNECTIVITY
    
    class func isConnectedToNetwork() -> Bool {
        
        var Status:Bool = false
        let url = URL(string: "http://google.com/")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "HEAD"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: URLResponse?
        
        do {
        var data = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response) as Foundation.Data?
        }
        catch let error as NSError {
            NSLog("Unresolved error \(error), \(error.userInfo)")
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                Status = true
            }
            
        }
    
        return Status
        
    }
}
