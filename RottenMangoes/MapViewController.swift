//
//  MapViewController.swift
//  RottenMangoes
//
//  Created by Michael Reining on 2/5/15.
//  Copyright (c) 2015 Mike Reining. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    // API URL Defaults
    let baseURL = "http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address="
    let midURL = "&movie="

    var movie: Movie?
    var userLocation: CLLocationCoordinate2D?
    var theatres = [Theatre]()
    var api : APIController?
    @IBOutlet weak var mapView: MKMapView!
    
    // Step 1 - Get User current location
    // Step 2 - Get user ZIP
    // Step 3 - Construct API URL
    // Step 4 - Process JSON file
    // Step 5 - Generate Array of Theatre results
    // Step 6 - Generate Pins for map based on results
    // Step 7 - Load Map view with current location and movie results
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Obtaining Location Information Permission
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }
    
    
}
