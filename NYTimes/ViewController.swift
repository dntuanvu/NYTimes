//
//  ViewController.swift
//  NYTimes
//
//  Created by Home on 25/9/17.
//  Copyright © 2017 Home. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var listNews: NSMutableArray = NSMutableArray()
    var selectedNews: Docs!
    
    var myView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    var page = 0
    var query = "singapore"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        myView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        myView.backgroundColor=UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        myView.alpha = 0.0
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            self.myView.alpha = 0.5
        })
        self.view.addSubview(myView)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.startAnimating()
        
        activityIndicator.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 2)
        
        myView.addSubview(activityIndicator)
        self.stopSpinner()
        
        self.fetchNews()
    }

    func spinner() {
        myView.isHidden = false
        myView.alpha = 0.0
        UIView.animate(withDuration: 1.0, animations: {
            self.myView.alpha = 0.5
        })
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    func stopSpinner() {
        myView.isHidden = true
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let size = CGSize(width: 300, height: 100)
        //return size
    }*/
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listNews.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NewsCollectionViewCell = self.mainCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NewsCollectionViewCell
        
        cell.layer.borderWidth = 0.3
        
        cell.titleLabel.text = (self.listNews.object(at: indexPath.row) as! Docs).headline.main!
        cell.snippetLabel.text = (self.listNews.object(at: indexPath.row) as! Docs).snippet!
        cell.dateLabel.text = (self.listNews.object(at: indexPath.row) as! Docs).pub_date!
        
        if (self.listNews.object(at: indexPath.row) as! Docs).multimedia.count > 0 {
            if let link = ((self.listNews.object(at: indexPath.row) as! Docs).multimedia.object(at: 1) as! Multimedia).url {
                print(link)
                if let checkedUrl = URL(string: "\(Constants.staticPath)\(link)") {
                    getDataFromUrl(url: checkedUrl) { (data, response, error)  in
                        guard let data = data, error == nil else { return }
                        
                        DispatchQueue.main.async() { () -> Void in
                            let myPicture = UIImage(data: data)!
                            cell.newsImageView.image = myPicture
                        }
                    }
                }
            }
        }
        
        if indexPath.row == self.listNews.count - 1 {
            self.page = self.page + 1
            self.fetchNews()
        }
        
        return cell
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let layout = self.mainCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = view.bounds.width
            let itemHeight = layout.itemSize.height
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.invalidateLayout()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedNews = self.listNews.object(at: indexPath.row) as! Docs
        self.performSegue(withIdentifier: "newsDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webDetail" {
            let detailVC: DetailWebViewController = segue.destination as! DetailWebViewController
            if let news = self.selectedNews {
                detailVC.webUrl = news.web_url!
            }
            
        } else if segue.identifier == "newsDetail" {
            let detailVC: DetailViewController = segue.destination as! DetailViewController
            if let news = self.selectedNews {
                detailVC.selectedNews = news
            }
        }
    }
    
    // MARK : UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(false, animated: true)
        self.page = 0
        self.query = "singapore"
        self.fetchNews()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(true, animated: true)
        self.page = 0
        self.query = searchBar.text!
        self.fetchNews()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(true, animated: true)
        self.page = 0
        self.query = searchBar.text!
        self.fetchNews()
    }
    
    // MARK: DataManager
    func fetchNews() {
        if self.page == 0 {
            self.spinner()
        }
        
        
        let url = "\(Constants.articleSearchAPI)&q=\(self.query)&page=\(self.page)"
        print(url)
        DataManager.shareInstance.getApiRequest(requestUrl: "\(url)", requestMethod: "GET", handler: { (success, data) in
            if self.page == 0 {
                self.stopSpinner()
            }
            
            if success {
                let info: [String: AnyObject] = Util.parseJson(data: data as! Data)
                print(info)
                
                let response = (info["response"] as AnyObject)["docs"] as AnyObject
                let docs: Docs = Docs()
                for resp in response as! NSArray {
                    if let snippet = (resp as AnyObject)["snippet"] {
                        docs.snippet = snippet as! String
                    }
                    
                    if let web_url = (resp as AnyObject)["web_url"] {
                        docs.web_url = web_url as! String
                    }
                    
                    let headline: Headline = Headline()
                    if let print_headline = ((resp as AnyObject)["headline"] as AnyObject)["print_headline"] {
                        if print_headline != nil {
                            headline.print_headline = print_headline as! String
                        } else {
                            headline.print_headline = ""
                        }
                    }
                    
                    if let main = ((resp as AnyObject)["headline"] as AnyObject)["main"] {
                        if main != nil {
                            headline.main = main as! String
                        } else {
                            headline.main = ""
                        }
                    }
                    
                    if let kicker = ((resp as AnyObject)["headline"] as AnyObject)["kicker"] {
                        if kicker != nil {
                            headline.kicker = kicker as! String
                        } else {
                            headline.kicker = ""
                        }
                    }
                    
                    docs.headline = headline
                    
                    let multimedias = (resp as AnyObject)["multimedia"] as! NSArray
                    if multimedias.count > 0 {
                        let listMultimedia: NSMutableArray = NSMutableArray()
                        
                        for media in multimedias {
                            print(media)
                            let multimedia: Multimedia = Multimedia()
                            
                            multimedia.type = (media as AnyObject)["type"] as! String
                            multimedia.subtype = (media as AnyObject)["subtype"] as! String
                            multimedia.url = (media as AnyObject)["url"] as! String
                            multimedia.height = (media as AnyObject)["height"] as! Int
                            multimedia.width = (media as AnyObject)["width"] as! Int
                            multimedia.rank = (media as AnyObject)["rank"] as! Int
                            
                            listMultimedia.add(multimedia)
                        }
                        
                        docs.multimedia = listMultimedia
                    }
                    
                    if let pub_date = (resp as AnyObject)["pub_date"] {
                        if pub_date != nil {
                            docs.pub_date = pub_date as! String
                        } else {
                            let date = Date()
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-mm-ddThh:mm:ss+z"
                            
                            docs.pub_date = formatter.string(from: date)
                        }
                    }
                    
                    self.listNews.add(docs)
                }
                
                self.mainCollectionView.reloadData()
            }
        })
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
}

