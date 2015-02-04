//
//  Movie.swift
//  RottenMangoes
//
//  Created by Michael Reining on 2/4/15.
//  Copyright (c) 2015 Mike Reining. All rights reserved.
//

import Foundation

class Movie {
    var title: String
    var movies = [Movie]()
    
    init(title: String) {
        self.title = title
    }
    
    class func getMoviesWithJSON(allResults: NSArray) -> [Movie] {
        
        var movies = [Movie]()
        
        if allResults.count>0 {
            for movieInfo in allResults {
            // Create the movie
                var title = movieInfo["title"] as? String
                
                var movie = Movie(title: title!)
                movies.append(movie)
                    
                }
        }
        return movies
    }
}
