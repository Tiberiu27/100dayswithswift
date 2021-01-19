//
//  ViewController.swift
//  Project22
//
//  Created by Tiberiu on 08.01.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var whichBeacon: UILabel!
    var circle: UIView!
    var locationManager: CLLocationManager?
    var alertShown = false
    //challenge 2 - make a list of uuids so I can tell which beacon is located
    let uuidList = ["5A4BCFCE-174E-4BAC-A814-092E77F6B7E5", "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        //challenge 3
        circle = UIView(frame: CGRect(x: 60, y: 260, width: 256, height: 256))
        circle.layer.cornerRadius = 128
        circle.layer.zPosition = -1
        self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        view.addSubview(circle)
        

        
        
        view.backgroundColor = .gray
    }
    //challenge 1
    func showAlert() {
        if !alertShown {
            let ac = UIAlertController(title: "Beacon detected!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(ac, animated: true)
            alertShown = true
        }

    }
    
    func startScanning() {
        let uuidF = UUID(uuidString: uuidList[0])!
        let uuidS = UUID(uuidString: uuidList[1])!
        let beaconRegionF = CLBeaconRegion(uuid: uuidF, major: 123, minor: 456, identifier: "MyBeacon")
        let beaconRegionS = CLBeaconRegion(uuid: uuidS, major: 123, minor: 456, identifier: "MySecondBeacon")
        let beaconRegionConstraints = CLBeaconIdentityConstraint(uuid: uuidF, major: 123, minor: 456)
        let beaconRegionSConstraints = CLBeaconIdentityConstraint(uuid: uuidS, major: 123, minor: 456)
        
        locationManager?.startMonitoring(for: beaconRegionF)
        locationManager?.startMonitoring(for: beaconRegionS)
        locationManager?.startRangingBeacons(satisfying: beaconRegionConstraints)
        locationManager?.startRangingBeacons(satisfying: beaconRegionSConstraints)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
            //challenge 2, figure out which beacon is based on it's uuid.
            if beacon.uuid.uuidString == uuidList[1] {
                whichBeacon.text = "The second beacon"
            } else if beacon.uuid.uuidString == uuidList[0] {
                whichBeacon.text = "The first beacon"
            }
            //challenge 1
            showAlert()
        } else {
            update(distance: .unknown)
        }
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) { [weak self] in
            switch distance {
            case .far:
                self?.circle.backgroundColor = UIColor.blue
                self?.circle.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                self?.distanceReading.text = "FAR"
            case .near:
                self?.circle.backgroundColor = UIColor.orange
                self?.circle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self?.distanceReading.text = "NEAR"
            case .immediate:
                self?.circle.backgroundColor = UIColor.red
                self?.circle.transform = CGAffineTransform(scaleX: 1, y: 1)
                self?.distanceReading.text = "RIGHT HERE"
            default:
                self?.circle.backgroundColor = UIColor.gray
                self?.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                self?.distanceReading.text = "UNKNOWN"
            }
        }
    }
}

