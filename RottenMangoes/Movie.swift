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
    var movies = [Movie]()
    
    init(title: String, thumbnailStringURL: String) {
        self.title = title
        self.thumbnailStringURL = thumbnailStringURL

    }
    
    class func getMoviesWithJSON(allResults: NSArray) -> [Movie] {
        
        var movies = [Movie]()
        
        if allResults.count>0 {
            for movieResult in allResults {
            // Create the movie
                var title = movieResult["title"] as String
                var postersDict: NSDictionary = movieResult["posters"] as NSDictionary
                    println(postersDict)
                var thumbnailStringURL = postersDict["thumbnail"] as String

                var movie = Movie(title: title, thumbnailStringURL: thumbnailStringURL)
                movies.append(movie)
                    
                }
        }
        return movies
    }
}

