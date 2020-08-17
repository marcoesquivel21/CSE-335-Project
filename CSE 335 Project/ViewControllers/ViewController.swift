//
//  ViewController.swift
//  CSE 335 Project
//
//  Created by Marco Esquivel on 3/21/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class ViewController: UIViewController {
    
    var user = User()
    let image = UIImage(named: "hiking.jpeg")?.jpegData(compressionQuality: 0.5)!
    let quoteModel = APIModel()
    

    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet var buttons: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //test hike
        //let hike = MyHike(name: "testName3", distance: "testDis", difficulty: "TESTDif", route: "TestR", rating: "TestR", journalEntry: "TestJ", image: image!)
        //user.addHike(h: hike)
        user.onLoad()
        self.quoteModel.getQuotes{[weak self] result in
            switch result{
            case .failure(let error):
                print(error)
            case .success(let quotes):
                print(quotes[self!.quoteModel.num])
                DispatchQueue.main.async {
                    self!.updateQuote(str: quotes[self!.quoteModel.num].text ?? "No Quote Available")
                }
            }
        }
        //api action
        
        
        for b in buttons{
            b.layer.cornerRadius = 20.0
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func returnToMenu(segue: UIStoryboardSegue){
        if segue.source is AddTrailViewController{
            let source = segue.source as! AddTrailViewController
            if source.hike != nil{
                user.hikeList.append(source.hike!)
                print(source.hike!.name)
            }
        }
    }
    
    func updateQuote(str : String){
        quoteLabel.text = str
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMyTrails"{
            let destination = segue.destination as! MyTrailsViewController
            destination.user = user
        }
    }


    
}

