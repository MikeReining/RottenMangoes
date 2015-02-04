//
//  ViewController.swift
//  RottenMangoes
//
//  Created by Michael Reining on 2/4/15.
//  Copyright (c) 2015 Mike Reining. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, APIControllerProtocol {
    let apiKey = "h8ym7ry7kkur36j7ku482y9z"
    let URL = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey="
    let pageLimit = "&page_limit=50"
    var movies = [Movie]()
    var api : APIController?

    override func viewDidLoad() {
        super.viewDidLoad()
        let myStringURL = URL + apiKey + pageLimit
        println(myStringURL)
        api = APIController(delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api?.getJSONResults(myStringURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // Did Receive API Results Method
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSArray = results["movies"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
        self.movies = Movie.getMoviesWithJSON(resultsArr)

        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }

}

