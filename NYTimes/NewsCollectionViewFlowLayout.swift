//
//  NewsCollectionViewFlowLayout.swift
//  NYTimes
//
//  Created by Home on 27/9/17.
//  Copyright © 2017 Home. All rights reserved.
//

import UIKit

class NewsCollectionViewFlowLayout : UICollectionViewFlowLayout {
    override init() {
        super.init()
        if #available(iOS 10.0, *) {
            estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        } else {
            // Fallback on earlier versions
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
