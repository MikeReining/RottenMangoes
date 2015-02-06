//
//  Theatre.swift
//  RottenMangoes
//
//  Created by Michael Reining on 2/5/15.
//  Copyright (c) 2015 Mike Reining. All rights reserved.
//

import Foundation

class Theatre {
    var id: String
    var name: String
    var address: String
    var lat: Double
    var lng: Double
    var zip: String?
    var distance: Double?
    var theatres = [Theatre]()
    
    init( id: String, name: String, address: String, lat: Double, lng: Double) {
        self.id = id
        self.name = name
        self.address = address
        self.lat = lat
        self.lng = lng
    }
    
    class func getTheatresWithJSON(allResults: NSArray) -> [Theatre] {
        
        var theatres = [Theatre]()
        
        if allResults.count>0 {
            for theatreResult in allResults {
                // Create the movie
                var id = theatreResult["id"] as String
                var name = theatreResult["name"] as String
                var address = theatreResult["address"] as String
                var lat = theatreResult["lat"] as Double
                var lng = theatreResult["lng"] as Double
                var theatre = Theatre(id: id, name: name, address: address, lat: lat, lng: lng)
                theatres.append(theatre)
                
            }
        }
        return theatres
    }
    
}