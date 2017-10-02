//
//  Util.swift
//  NYTimes
//
//  Created by Home on 25/9/17.
//  Copyright © 2017 Home. All rights reserved.
//

import Foundation

class Util {
    
    static func parseJson(data: Data) -> [String: AnyObject] {
        var info = [String: AnyObject]()
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                info = json
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return info
    }
    
}
