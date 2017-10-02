//
//  DetailViewController.swift
//  NYTimes
//
//  Created by Home on 27/9/17.
//  Copyright © 2017 Home. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var snippetLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var selectedNews: Docs!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let detail = self.selectedNews {
            if detail.multimedia.count > 0 {
                if let link = (detail.multimedia.object(at: 0) as! Multimedia).url {
                    if let checkedUrl = URL(string: "\(Constants.staticPath)\(link)") {
                        getDataFromUrl(url: checkedUrl) { (data, response, error)  in
                            guard let data = data, error == nil else { return }
                            
                            DispatchQueue.main.async() { () -> Void in
                                let myPicture = UIImage(data: data)!
                                self.newsImageView.image = myPicture
                            }
                        }
                    }
                }
            }
            
            
            self.snippetLabel.text = selectedNews.snippet!
            self.headlineLabel.text = selectedNews.headline!.main!
            self.contentLabel.text = selectedNews.pub_date!
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
    
}
