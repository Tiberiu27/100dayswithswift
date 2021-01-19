//
//  ViewController.swift
//  Project16
//
//  Created by Tiberiu on 01.01.2021.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map View", style: .plain, target: self, action: #selector(changeMap))
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 summer Olympics")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        
        
        mapView.addAnnotation(london)
        mapView.addAnnotation(oslo)
        mapView.addAnnotation(paris)
        mapView.addAnnotation(rome)
        mapView.addAnnotation(washington)
    }
    //challenge 2
    @objc func changeMap() {
        let ac = UIAlertController(title: "Map Style", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Satelite", style: .default, handler: changeSatelite))
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: changeHybrid))
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: changeStandard))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    func changeSatelite(action: UIAlertAction) {
        mapView.mapType = .satellite
    }
    func changeStandard(action: UIAlertAction) {
        mapView.mapType = .standard
    }
    func changeHybrid(action: UIAlertAction) {
        mapView.mapType = .hybrid
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //1
        guard annotation is Capital else { return nil }
        
        //2
        let identifier = "Capital"
        
        //3
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            //4
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            //5
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            //6
            annotationView?.annotation = annotation
        }
        //challenge 1
        annotationView?.pinTintColor = UIColor.green
        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        let placeName = capital.title

        //challenge 3
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailWebViewController {
            vc.capitalUrl = "https://en.wikipedia.org/wiki/\(placeName ?? "")"
            navigationController?.pushViewController(vc, animated: true)
        }

    }
}

