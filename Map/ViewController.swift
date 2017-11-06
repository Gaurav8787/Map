//
//  ViewController.swift
//  Map
//
//  Created by Gaurav on 02/11/17.
//  Copyright © 2017 Gaurav. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var myMapView: MKMapView!
    var locationFixAchieved : Bool = false
    
    var locmanager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locmanager.delegate = self as? CLLocationManagerDelegate
        locmanager.desiredAccuracy = kCLLocationAccuracyBest
        
        myMapView.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            myMapView.showsUserLocation = true
        } else {
            
//            locmanager.requestAlwaysAuthorization()
            locmanager.requestWhenInUseAuthorization()
            
        }
        
       // let loc = CLLocation(latitude: 21.282778, longitude: -157.829444)
        
//        let coregion = MKCoordinateRegionMakeWithDistance(loc.coordinate, 1000, 1000)
//        myMapView.setRegion(coregion, animated: true)
        
        locmanager.startUpdatingLocation()
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations[0]
        _didComplete(location: location, error: nil)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
    
    private func _didComplete(location: CLLocation?, error: NSError?) {
        
         if (locationFixAchieved == false) {
            locationFixAchieved = true
            let coregion = MKCoordinateRegionMakeWithDistance((location?.coordinate)!, 1000, 1000)
            myMapView.setRegion(coregion, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = (location?.coordinate)!
            annotation.title = "place"
            self.myMapView.addAnnotation(annotation)
            
            locmanager.stopUpdatingLocation()
            _didComplete(location: location, error: error)
            locmanager.delegate = nil
            
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func zoompressed(_ sender: Any) {
        
        let userLocation = myMapView.userLocation
        
        if userLocation != nil {
            let coregion = MKCoordinateRegionMakeWithDistance((userLocation.coordinate), 900, 900)
            
            myMapView.setRegion(coregion, animated: true)
        }
        
        
        
    }
    
    @IBAction func typepessed(_ sender: Any) {
        
        if myMapView.mapType == MKMapType.standard {
            myMapView.mapType = MKMapType.satellite
        } else {
            myMapView.mapType = MKMapType.standard
        }
        
    }
    
}

extension ViewController: MKMapViewDelegate {
    
    //   1
    //  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    //    guard let annotation = annotation as? Artwork else { return nil }
    //    // 2
    //    let identifier = "pin"
    //    var view: MKMarkerAnnotationView
    //    if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
    //      as? MKMarkerAnnotationView { // 3
    //      dequeuedView.annotation = annotation
    //      view = dequeuedView
    //    } else {
    //      // 4
    //      view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
    //      view.canShowCallout = true
    //      view.calloutOffset = CGPoint(x: -5, y: 5)
    //      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    //    }
    //    return view
    //  }
  
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
//        let location = view.annotation as! Artwork
//        let launchOptions = [MKLaunchOptionsDirectionsModeKey:
//            MKLaunchOptionsDirectionsModeDriving]
//        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
}

