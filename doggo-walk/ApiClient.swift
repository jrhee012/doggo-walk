//
//  ApiClient.swift
//  doggo-walk
//
//  Created by Jaehyuk Rhee on 4/10/19.
//  Copyright © 2019 Jaehyuk Rhee. All rights reserved.
//

import Foundation

class ApiClient {
    public func syncRequest(request: NSMutableURLRequest) -> NSDictionary {
        let semaphore = DispatchSemaphore(value: 0)
        var result: NSDictionary = [:]
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {(data, response, error) in
            guard let data = data, error == nil else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                result = json
                semaphore.signal()
            } catch let error as NSError {
                print(error)
            }
        }
        
        task.resume()
        semaphore.wait()
        return result
    }
    
    public func asyncRequest(request: NSMutableURLRequest) {
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            // Check for error
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    // Print out dictionary
                    print(convertedJsonIntoDict)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
}
