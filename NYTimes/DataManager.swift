//
//  DataManager.swift
//  NYTimes
//
//  Created by Home on 25/9/17.
//  Copyright © 2017 Home. All rights reserved.
//

import Foundation

class DataManager {
    
    static let shareInstance = DataManager()
    
    typealias HelperCompletionHandler = (_ success: Bool, _ info: AnyObject?) -> Void
    var data : AnyObject!
    var error : String!
    
    func getApiRequest (requestUrl: String, requestMethod: String, handler: HelperCompletionHandler?) {
        let url:URL = URL(string: requestUrl)!
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = requestMethod
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let task = session.dataTask(with: request as URLRequest) {(data, response, error) in
            guard let data = data, let _:URLResponse = response, error == nil else {
                print("error")
                return
            }
            
            if let response = response {
                let httpResponse = response as! HTTPURLResponse
                print("response code = \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 200{
                    handler!(true, data as AnyObject?)
                } else {
                    handler!(false, data as AnyObject?)
                }
            }
        }
        
        task.resume()
    }
    
    func postApiRequest(requestUrl: String, requestMethod: String, params: String, handler: HelperCompletionHandler?) {
        let url:URL = URL(string: requestUrl)!
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = requestMethod
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        //let paramString = "data=Hello"
        let paramString = params
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        print(params)
        let task = session.dataTask(with: request as URLRequest) {(data, response, error) in
            guard let data = data, let _:URLResponse = response, error == nil else {
                print("error")
                return
            }
            
            if let response = response {
                let httpResponse = response as! HTTPURLResponse
                print("response code = \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 200{
                    handler!(true, data as AnyObject?)
                } else {
                    handler!(false, data as AnyObject?)
                }
            }
            
            //dataString =  String(data: data, encoding: String.Encoding.utf8)!
            //print(dataString)
        }
        
        task.resume()
    }
    
}
