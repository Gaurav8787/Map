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
    var myloc:CLLocation?
    
    var myRoute : MKRoute!
    
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
            myloc = location
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
        
//        if userLocation != nil {
        let coregion = MKCoordinateRegionMakeWithDistance((self.myloc?.coordinate)!, 500, 500)
            
            myMapView.setRegion(coregion, animated: true)
//        }
        
        
        
    }
    
    @IBAction func typepessed(_ sender: Any) {
        
        if myMapView.mapType == MKMapType.standard {
            myMapView.mapType = MKMapType.satellite
        } else {
            myMapView.mapType = MKMapType.standard
        }
        
    }
    
    @IBAction func roadmappressed(_ sender: UIButton) {
        
        let point1 = MKPointAnnotation()
        let point2 = MKPointAnnotation()
        
        point1.coordinate = CLLocationCoordinate2DMake(25.0305, 121.5360)
        point1.title = "Taipei"
        point1.subtitle = "Taiwan"
        myMapView.addAnnotation(point1)
        
        point2.coordinate = CLLocationCoordinate2DMake(24.9511, 121.2358)
        point2.title = "Chungli"
        point2.subtitle = "Taiwan"
        myMapView.addAnnotation(point2)
        myMapView.centerCoordinate = point2.coordinate
        
        myMapView.setRegion(MKCoordinateRegionMake(point2.coordinate, MKCoordinateSpanMake(0.7,0.7)), animated: true)
        
        let directionsRequest = MKDirectionsRequest()
        
        let markTaipei = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point1.coordinate.latitude, point1.coordinate.longitude), addressDictionary: nil)
        
        let markChungli = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point2.coordinate.latitude, point2.coordinate.longitude), addressDictionary: nil)
        
        directionsRequest.source = MKMapItem(placemark: markChungli)
        directionsRequest.destination = MKMapItem(placemark: markTaipei)
        
        directionsRequest.transportType = MKDirectionsTransportType.automobile
        
        let directions = MKDirections(request: directionsRequest)
        
        directions.calculate(completionHandler: {
            
            response, error in
            
            if error == nil {
                
                self.myRoute = response!.routes[0] as MKRoute
                
                self.myMapView.add(self.myRoute.polyline)
                
            }
        })
        
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
  
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            print("selected \(String(describing: view.annotation?.coordinate)) ff \(String(describing: view.annotation?.title))")
            
    
    }
    
    func mapView(_ mapView: MKMapView,
                 rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        if (overlay is MKPolyline) {
            if mapView.overlays.count == 1 {
                polylineRenderer.strokeColor =
                    UIColor.blue.withAlphaComponent(0.75)
            } else if mapView.overlays.count == 2 {
                polylineRenderer.strokeColor =
                    UIColor.green.withAlphaComponent(0.75)
            } else if mapView.overlays.count == 3 {
                polylineRenderer.strokeColor =
                    UIColor.red.withAlphaComponent(0.75)
            }
            polylineRenderer.lineWidth = 5
        }
        return polylineRenderer
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
//        let location = view.annotation as! Artwork
//        let launchOptions = [MKLaunchOptionsDirectionsModeKey:
//            MKLaunchOptionsDirectionsModeDriving]
//        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
}

