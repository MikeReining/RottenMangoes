//
//  Review.swift
//  RottenMangoes
//
//  Created by Michael Reining on 2/4/15.
//  Copyright (c) 2015 Mike Reining. All rights reserved.
//

import Foundation

class Review {
    var critic: String
    var quote: String
    var reviews = [Review]()
    
    init(critic: String, quote: String) {
        self.critic = critic
        self.quote = quote
    }

    class func getReviesWithJSON(allResults: NSArray) -> [Review] {
        
        var reviews = [Review]()
        
        if allResults.count>0 {
            for reviewInfo in allResults {
                // Create the movie
                var critic = reviewInfo["critic"] as String
                var quote = reviewInfo["quote"] as String
                
                var newReview = Review(critic: critic, quote: quote)
                reviews.append(newReview)
                
            }
        }
        return reviews
    }

}