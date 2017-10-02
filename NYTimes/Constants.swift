//
//  Constants.swift
//  NYTimes
//
//  Created by Home on 25/9/17.
//  Copyright © 2017 Home. All rights reserved.
//

import Foundation

class Constants {
    
    static let hostName = "https://api.nytimes.com/"
    
    static let apiKey = "9e8111a3799346e98ed4f7a58c8400bc"
    //static let apiKey = "5763846de30d489aa867f0711e2b031c"
    
    static let staticPath = "https://static01.nyt.com/"
    
    //static let getNewsAPI = "\(Constants.hostName)/svc/search/v2/articlesearch.json?api-key=\(Constants.apiKey)&q=singapore&page=0"
    static let articleSearchAPI = "\(Constants.hostName)/svc/search/v2/articlesearch.json?api-key=\(Constants.apiKey)&sort=newest"
    
}
