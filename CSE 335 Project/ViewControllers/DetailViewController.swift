//
//  DetailViewController.swift
//  CSE 335 Project
//
//  Created by Marco Esquivel on 4/21/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var hike:MyHike?

    @IBOutlet var buttonStyle: [UIButton]!
    @IBOutlet weak var hikePic: UIImageView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet var textAreas: [UITextView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for b in buttonStyle{
            b.layer.cornerRadius = 15.0
        }
        populateTextFields()
        populateImage()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func saveChanges(_ sender: Any) {
        for t in textAreas{
                   switch t.tag {
                   case 0:
                    hike!.journalEntry = t.text
                    print("Changes Saved")
                   case 1:
                    hike!.rating = t.text
                   case 2:
                    hike!.distance = t.text
                   case 3:
                    hike!.difficulty = t.text
                   case 4:
                    hike!.route = t.text
                   default:
                       print("Error")
                   }
               }
        
    }
    
    func populateTextFields(){
        navBar.topItem?.title = hike!.name
        for t in textAreas{
            switch t.tag {
            case 0:
                t.text = hike!.journalEntry
            case 1:
                t.text = hike!.rating
            case 2:
                t.text = hike!.distance
            case 3:
                t.text = hike!.difficulty
            case 4:
                t.text = hike!.route
            default:
                print("Error")
            }
        }
    }
    
    func populateImage(){
        if hike!.image != nil{
            let tempIm = UIImage(data: hike!.image!)
            hikePic.image = tempIm
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMap"{
            let destination = segue.destination as! MapViewController
            destination.hike = hike
        }
    }
    
    @IBAction func backToDetail(segue: UIStoryboardSegue){
        
    }
    

}
