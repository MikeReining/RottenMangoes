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
    
    @IBOutlet weak var movieNameLabel: UILabel!
    override func viewDidLoad() {
        
        movieNameLabel.text = "test"
    }

}

