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
    var thumbnailStringURL: String
    var movieID: String
    var movies = [Movie]()
    
    init(title: String, thumbnailStringURL: String, movieID: String) {
        self.title = title
        self.thumbnailStringURL = thumbnailStringURL
        self.movieID = movieID

    }
    
    class func getMoviesWithJSON(allResults: NSArray) -> [Movie] {
        
        var movies = [Movie]()
        
        if allResults.count>0 {
            for movieResult in allResults {
            // Create the movie
                var title = movieResult["title"] as String
                var movieID = movieResult["id"] as String
                var postersDict: NSDictionary = movieResult["posters"] as NSDictionary
                var thumbnailStringURL = postersDict["thumbnail"] as String

                var movie = Movie(title: title, thumbnailStringURL: thumbnailStringURL, movieID: movieID)
                movies.append(movie)
                    
                }
        }
        return movies
    }
}

