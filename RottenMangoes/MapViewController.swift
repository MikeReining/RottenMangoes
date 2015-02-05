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
    
    //MARK: Location Manager Delegate
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        println("New location")
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        //1 grab current location
        var currentLocation = locations.last as CLLocation
        //2 create location point for map based on current location
        var location = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        //3 define layout for map
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let userPoint = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(userPoint, animated: true)
        
        //4 add annotation to current location
        let annotation = MKPointAnnotation()
        annotation.setCoordinate(location)
        annotation.title = "Where am I?"
        annotation.subtitle = "I am here!"
        mapView.addAnnotation(annotation)
        //5 stop updatinglocation
        locationManager.stopUpdatingLocation()
        
        
        // Reverse GEOCode
        reverseGEOCodeFromCurrentLocation(manager)
        
    }
    
    // Reverse GeoCode Function to extract address from current Location
    func reverseGEOCodeFromCurrentLocation(manager: CLLocationManager) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println(error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                println("Problem with the data received from geocoder")
            }
        })
    }
    
    // Print location details for GEO Lookup
    
    func displayLocationInfo(placemark: CLPlacemark) {
        if placemark.postalCode != nil {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            println(placemark.locality)
            println(placemark.postalCode)
            println(placemark.administrativeArea)
            println(placemark.country)
        }
    }

}
