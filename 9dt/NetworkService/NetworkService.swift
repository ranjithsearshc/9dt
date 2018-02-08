//
//  dt9NetworkService.swift
//  9dt
//
//  Created by Kumar, Ranjith (Contractor) on 2/6/18.
//  Copyright © 2018 Kumar, Ranjith (Contractor). All rights reserved.
//

import Foundation

class NetworkService {
    static var client: NetworkService?
    
    static func sharedInstance() -> NetworkService {
        if client == nil {
            client = NetworkService()
        }
        
        return client!
    }
    
    func getServiceEndpoints(points:[Int], withCallback completionHandler: @escaping (_ result: [Int]?, _ error: Error?) -> Void) {
        let headers = [
            "cache-control": "no-cache"
        ]
        
        var baseUrl = constants.baseurl
        
        for point in points {
            baseUrl = "\(baseUrl)\(point),"
        }
        
        if points.count > 0 {
            baseUrl = String(baseUrl.dropLast())
        }
        baseUrl = "\(baseUrl)]"
        print(baseUrl)
        
        let request = NSMutableURLRequest(url: NSURL(string: baseUrl)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 20.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print(error!.localizedDescription)
                completionHandler(nil,error)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                completionHandler(nil,error)
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let result = try JSONSerialization.jsonObject(with: responseData, options: []) as? [Int] else {
                    print("error trying to convert data to JSON")
                    completionHandler(nil,error)
                    return
                }
                // now we have the todo, let's just print it to prove we can access it
                print("The todo is: " + result.description)
                completionHandler(result,nil)
                
                
            } catch  {
                completionHandler(nil,error)
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
}
