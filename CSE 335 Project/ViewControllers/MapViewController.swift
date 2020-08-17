//
//  MapViewController.swift
//  CSE 335 Project
//
//  Created by Marco Esquivel on 4/21/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var searchBut: UIButton!
    @IBOutlet weak var errorPrompt: UILabel!
    @IBOutlet weak var mapType: UISegmentedControl!
    @IBOutlet weak var hikeMap: MKMapView!
    
    @IBOutlet weak var cityText: UITextField!
    var hike:MyHike?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hikeMap.delegate = self
        navBar.topItem?.title = hike!.name
        searchBut.layer.cornerRadius = 10.0
        makeMap()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func segControlAction(_ sender: Any) {
        switch mapType.selectedSegmentIndex {
        case 0:
            self.hikeMap.mapType = MKMapType.standard
        case 1:
            self.hikeMap.mapType = MKMapType.satellite
        default:
            print("never")
        }
    }
    
   func makeMap(){
       let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(hike!.name, completionHandler: {(placemarks, error)in

           if error != nil{
               print("Couldn't find Hike")
               self.errorPrompt.isHidden = false
           }else{
               let placemark = placemarks![0]
               let location = placemark.location
               let coords = location!.coordinate
                
               print(coords)

               let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
               let region = MKCoordinateRegion(center: coords, span: span)
               self.hikeMap.setRegion(region, animated: true)
               let ani = MKPointAnnotation()
               ani.coordinate = coords
               ani.title = self.hike?.name
               self.hikeMap.addAnnotation(ani)
           }
       })

   }
    
    @IBAction func searchLocal(_ sender: Any) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(cityText.text ?? "", completionHandler: {(placemarks, error) in
            if error != nil{
                print("Error")
            }else if placemarks!.count > 0{
                self.errorPrompt.isHidden = true
                let placemark = placemarks![0]
                let location = placemark.location
                let coords = location!.coordinate
                
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                var region = MKCoordinateRegion(center: coords, span: span)
                
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = self.hike!.name
                request.region = region
                let search = MKLocalSearch(request: request)
                
                search.start { response,_ in guard let response = response else{ return}
                    var matchingItems:[MKMapItem] = []
                    matchingItems = response.mapItems
                    let p = matchingItems[0].placemark
                    let location = p.location
                    let coords = location!.coordinate
                    region = MKCoordinateRegion(center: coords, span: span)
                    
                    let ani = MKPointAnnotation()
                    ani.coordinate = coords
                    ani.title = p.name
                    self.hikeMap.setRegion(region, animated: true)
                    self.hikeMap.addAnnotation(ani)
                        
                }
            }
        })
    }
    
}
