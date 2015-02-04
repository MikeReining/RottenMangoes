//
//  MovieDetailsViewController.swift
//  RottenMangoes
//
//  Created by Michael Reining on 2/4/15.
//  Copyright (c) 2015 Mike Reining. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController, APIControllerProtocol {
    var movie: Movie?
    let apiKey = "h8ym7ry7kkur36j7ku482y9z"
    let baseURL = "http://api.rottentomatoes.com/api/public/v1.0/movies/"
    let midURL = "/reviews.json?apikey="
    let endURL = "&page_limit=3"
    var reviews = [Review]()
    var api : APIController?

    
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var review1Label: UILabel!
    
    override func viewDidLoad() {
        let movieID = String(movie!.movieID)
        let myStringURL = baseURL + movieID + midURL + apiKey + endURL
        println(myStringURL)
        api = APIController(delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api?.getJSONReviewResults(myStringURL)
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        movieNameLabel.text = movie?.title
    }
    
    

    //MARK API Controller Protocol Methods
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSArray = results["reviews"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.reviews = Review.getReviesWithJSON(resultsArr)
            self.review1Label.text = self.reviews[0].quote
            self.refreshGUI()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }

    func refreshGUI() {
        self.view.setNeedsDisplay()
    }
    
}

