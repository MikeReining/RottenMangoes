//
//  MovieDetailsViewController.swift
//  RottenMangoes
//
//  Created by Michael Reining on 2/4/15.
//  Copyright (c) 2015 Mike Reining. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    var movie: Movie?
    let apiKey = "h8ym7ry7kkur36j7ku482y9z"
    let baseURL = "http://api.rottentomatoes.com/api/public/v1.0/movies/"
    let midURL = "/reviews.json?apikey="
    let endURL = "&page_limit=3"
    
    
    @IBOutlet weak var movieNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        let movieID = String(movie!.movieID)
        let myStringURL = baseURL + movieID + midURL + apiKey + endURL
        println(myStringURL)
        
        
        movieNameLabel.text = movie?.title
    }

}

