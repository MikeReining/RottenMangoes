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
    @IBOutlet var moviesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myStringURL = URL + apiKey + pageLimit
        api = APIController(delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api?.getJSONResults(myStringURL, searchFor: "movies")
        self.navigationController?.setToolbarHidden(false, animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK API Controller Protocol Methods
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSArray = results["movies"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
        self.movies = Movie.getMoviesWithJSON(resultsArr)
        self.moviesTableView.reloadData()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }

    //MARK: Table View Methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as MovieCell
        let movie = movies[indexPath.row]
        let movieName = movie.title
        cell.movieName.text = movieName


        return cell
    }
    
    //MARK: Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCollectionView" {
            let nvc = segue.destinationViewController as CollectionViewController
            nvc.movies = movies
        }
        
        if segue.identifier == "tableMovieDetails" {
            let nvc = segue.destinationViewController as MovieDetailsViewController
            let indexPath = moviesTableView.indexPathForSelectedRow()?.row
            let movie = movies[indexPath!] as Movie
            nvc.movie = movie
        }
    }
    
    
}

