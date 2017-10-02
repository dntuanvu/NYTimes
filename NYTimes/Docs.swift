//
//  Docs.swift
//  NYTimes
//
//  Created by Home on 25/9/17.
//  Copyright © 2017 Home. All rights reserved.
//

import Foundation

class Docs {
    
    var web_url: String!
    var snippet: String!
    var print_page: Int!
    
    var source: String!
    var multimedia: NSMutableArray = NSMutableArray()
    
    var news_image: String!
    var title: String!
    
    var headline: Headline!
    var keywords: NSMutableArray!
    
    var pub_date: String!
    var document_type: String!
    var new_desk: String!
    
    var type_of_material: String!
    var word_count: Int!
    var score: Double!
    var uri: String!
    
}
