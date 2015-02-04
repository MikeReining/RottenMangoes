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
    var thumbnail: String
    var movies = [Movie]()
    
    init(title: String, thumbnail: String) {
        self.title = title
        self.thumbnail = thumbnail

    }
    
    class func getMoviesWithJSON(allResults: NSArray) -> [Movie] {
        
        var movies = [Movie]()
        
        if allResults.count>0 {
            for movieResult in allResults {
            // Create the movie
                var title = movieResult["title"] as String
                var postersDict: NSDictionary = movieResult["posters"] as NSDictionary
                    println(postersDict)
                var thumbnail = postersDict["thumbnail"] as String

                var movie = Movie(title: title, thumbnail: thumbnail)
                movies.append(movie)
                    
                }
        }
        return movies
    }
}

