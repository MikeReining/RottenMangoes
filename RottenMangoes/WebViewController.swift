//
//  WebViewController.swift
//  RottenMangoes
//
//  Created by Michael Reining on 2/4/15.
//  Copyright (c) 2015 Mike Reining. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    var movie: Movie?

    
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        let baseURL = "http://www.rottentomatoes.com/"
//        let movieTitle = movie!.title
//        
//        var movieTitleURL: NSString = movieTitle.stringByReplacingOccurrencesOfString(" ", withString: "_", options: nil, range: nil)
        
        
        let url = NSURL(string: baseURL)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
    
    
    
    
}
