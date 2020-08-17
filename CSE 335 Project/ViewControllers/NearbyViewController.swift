//
//  NearbyViewController.swift
//  CSE 335 Project
//
//  Created by Marco Esquivel on 4/21/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class NearbyViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var sendRegion:MKCoordinateRegion?
    var sendingCoords:CLLocationCoordinate2D?
    
    var runOnce = false
    
    @IBOutlet weak var nearbyTable: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return near.nearbyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyTrailsTableViewCell
        
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 2
        cell.textLabel?.text = near.nearbyList[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let source = MKMapItem(placemark: MKPlacemark(coordinate: sendingCoords!))
        source.name = "Current Location"
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = near.nearbyList[indexPath.row]
        request.region = sendRegion!
               
               let search = MKLocalSearch(request: request)
               
               search.start {response, _ in
                   guard let response = response else{
                       return
                   }
                   let destination = response.mapItems[0]
                destination.name = self.near.nearbyList[indexPath.row]
                MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
               }
        return indexPath
    }
   
    
    
    
    
    
    var manager:CLLocationManager!
    
    var near = NearbyHikes()

    override func viewDidLoad() {
        super.viewDidLoad()
        if !runOnce{
            manager = CLLocationManager()
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        }
        runOnce = true
        nearbyTable.delegate = self
        nearbyTable.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLoc = locations[0]
        let coords = userLoc.coordinate
        sendingCoords = coords
        let span = MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
        let region = MKCoordinateRegion(center: coords, span: span)
        sendRegion = region
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Hiking"
        request.region = region
        let search = MKLocalSearch(request: request)
        search.start { response,_ in guard let response = response else{ return}
            var matchingItems:[MKMapItem] = []
            matchingItems = response.mapItems
            for p in matchingItems{
                if !self.near.nearbyList.contains(p.name!){
                    self.near.nearbyList.append(p.name!)
                    print(p.name!)
                }
            }
            DispatchQueue.main.async {
                self.nearbyTable.reloadData()
            }
        }
        
    }
    

    @IBAction func backToNearby(segue: UIStoryboardSegue){
        
    }
    
}
