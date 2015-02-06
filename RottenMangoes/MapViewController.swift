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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, APIControllerProtocol, UITableViewDataSource, UITableViewDelegate {
    let locationManager = CLLocationManager()
    var movie: Movie?
    var theatres = [Theatre]()
    var theatresByDistance = [Theatre]()
    var annotations = [AnyObject]()
    var api : APIController?
    var zipForURL: NSString?
    var newZipCodeLocation: CLLocation?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    // Step 1 - Get User current location - DONE
    // Step 2 - Get user ZIP - DONE
    // Step 3 - Construct API URL - DONE
    // Step 4 - Process JSON file - DONE
    // Step 5 - Generate Array of Theatre results - DONE
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
        mapView.delegate = self
    }
    
    //MARK: Location Manager Delegate
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        let currentLocation = CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
        distanceToAnnotations(currentLocation)
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        //1 grab current location
        var currentLocation = locations.last as CLLocation
        //2 create location point for map based on current location
        var location = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        //3 define layout for map
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let userPoint = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(userPoint, animated: true)
        
        //4 stop updatinglocation
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
            locationManager.stopUpdatingLocation()
            var rawZipCode = placemark.postalCode
            zipForURL = rawZipCode.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
            var movieNameForURL = movie?.title.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: nil, range: nil)
            generateJSONURL(zipForURL!, movieName: movieNameForURL!)
        }
    }
    
    func generateJSONURL(zipForURL: String,movieName: String) {
        // API URL Defaults
        let baseURL = "http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address="
        let midURL = "&movie="
        let myStringURL = baseURL + zipForURL + midURL + movieName
        print(myStringURL)
        api = APIController(delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api?.getJSONResults(myStringURL, searchFor: "theatres")

        
    }
    
    //MARK API Controller Protocol Methods
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSArray = results["theatres"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.theatres = Theatre.getTheatresWithJSON(resultsArr)

            self.refreshGUI()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            println(self.theatres[0].name)
        })
    }
    
    func refreshGUI() {
        addAnnotationsToMapView(theatres)
        self.view.setNeedsDisplay()
    }
    
    //Add Pins / Annotations to Map view
    func addAnnotationsToMapView(arrayOfLocations: [Theatre]) {
        for theatre in arrayOfLocations {
            let annotation = MKPointAnnotation()
            var location = CLLocationCoordinate2D(latitude: theatre.lat, longitude: theatre.lng)
            annotation.setCoordinate(location)
            annotation.title = theatre.name
            annotation.subtitle = theatre.address
            annotations.append(annotation)
            mapView.addAnnotation(annotation)
        }

        
    }
    
    func mapView(mapView: MKMapView!,
        viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
            
            if annotation is MKUserLocation {
                //return nil so map view draws "blue dot" for standard user location
                return nil
            }
            
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.animatesDrop = true
                pinView!.pinColor = .Red
            }
            else {
                pinView!.annotation = annotation
            }
            
            return pinView
    }
    
    //MARK Table View Delegates Calculate distance to locations
    func distanceToAnnotations(currentLocation: CLLocation) {
        for theatre in theatres {
            var theatreLocation = CLLocation(latitude: theatre.lat, longitude: theatre.lng)
            theatre.distance = theatreLocation.distanceFromLocation(currentLocation)
        }
        theatresByDistance = theatres
        theatresByDistance.sort({ $0.distance < $1.distance })
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theatresByDistance.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TheatreCell", forIndexPath: indexPath) as UITableViewCell
        let movieName = theatresByDistance[indexPath.row].name
        cell.textLabel?.text = movieName.truncate(35, trailing: "...")
        let distance = theatresByDistance[indexPath.row].distance! / 1000
        
        cell.detailTextLabel?.text = NSString(format:"%.2f km", distance)
        return cell
        
    }
    
    //MARK Search By Zip
    
    @IBAction func searchByZipButtonPressed(sender: AnyObject) {
        var alert = UIAlertController(title: "Search By Zip Code", message: "Please enter zip code below", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action: UIAlertAction!) -> Void in
            // 0 remove annotations from map
            self.mapView.removeAnnotations(self.annotations)
            // 1 caputre string entered by user
            let textField = alert.textFields![0] as UITextField
            let rawZipCode = textField.text
            self.refreshGUI()
            // 2 find new user location on map
            self.GEOCodeFromZipCode(rawZipCode)
            // 3. Update map with new location
            
            // 2 turn zip into clean zipForURL
            let zipForURL = rawZipCode.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
            var movieNameForURL = self.movie?.title.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: nil, range: nil)
            // 3 generate URL >> calls function to process JSON >> Calls function generate new theatre array
            self.generateJSONURL(zipForURL, movieName: movieNameForURL!)
            // 5 create new map annotations
            self.addAnnotationsToMapView(self.theatres)
            // 6 calculate new distances >> reloads table
            let currentLocation = CLLocation(latitude: self.mapView.userLocation.coordinate.latitude, longitude: self.mapView.userLocation.coordinate.longitude)
            self.distanceToAnnotations(currentLocation)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction!) -> Void in
            
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    // Function to lookup new user location based on ZIP
    func GEOCodeFromZipCode(zipCode: String) {
        CLGeocoder().geocodeAddressString(zipCode, {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                var placemarkLocation: CLLocation = placemark.location
                self.newZipCodeLocation = placemarkLocation
            }
        })
        
    }
    
}

extension String {
    /// Truncates the string to length number of characters and
    /// appends optional trailing string if longer
    func truncate(length: Int, trailing: String? = nil) -> String {
        if countElements(self) > length {
            return self.substringToIndex(advance(self.startIndex, length)) + (trailing ?? "")
        } else {
            return self
        }
    }
}
