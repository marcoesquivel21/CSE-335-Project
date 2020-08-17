//
//  AddTrailViewController.swift
//  CSE 335 Project
//
//  Created by Marco Esquivel on 3/21/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import UIKit

class AddTrailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var tempUser:User = User()
    let picker = UIImagePickerController()
    var imageData:Data?
    var hike:MyHike?

    @IBOutlet weak var journalArea: UITextView!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var textFields: [UITextField]!
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        for b in buttons{
            b.layer.cornerRadius = 20.0
        }

        // Do any additional setup after loading the view.
    }
    

    @IBAction func addHike(_ sender: Any) {
        var tempName = ""
        var tempDistance = ""
        var tempDifficulty = ""
        var tempRoute = ""
        var tempRating = ""
        var tempJournal = ""
        for t in textFields{
            switch t.tag {
            case 0:
                tempName = t.text ?? "No Name"
            case 1:
                tempDistance = t.text ?? "Distance not Given"
            case 2:
                tempDifficulty = t.text ?? "No Difficulty"
            case 3:
                tempRoute = t.text ?? "Route not Given"
            case 4:
                tempRating = t.text ?? "Not Rated"
            default:
                print("Error")
            }
            
        }
        tempJournal = journalArea.text
        hike = MyHike(name: tempName, distance: tempDistance, difficulty: tempDifficulty, route: tempRoute, rating: tempRating, journalEntry: tempJournal, image: imageData ?? nil)
        tempUser.addHike(h: hike!)

        
        //let tempHike:MyHike = MyHike(n: tempName, dist: tempDistance, diff: tempDifficulty, rou: tempRoute, rat: tempRating, j: tempJournal, i: "")
        
        //tempUser.addHike(h: tempHike)
        
        for t in textFields{
            t.text = ""
        }
        journalArea.text = ""
        
        performSegue(withIdentifier: "hikeAdded", sender: self)
        
    }
    
    @IBAction func imageUpload(_ sender: Any) {
        
        let alert = UIAlertController.init(title: "Select Source Type", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                self.picker.allowsEditing = false
                self.picker.sourceType = UIImagePickerController.SourceType.camera
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker,animated: true,completion: nil)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (_) in
                self.picker.allowsEditing = false
                self.picker.sourceType = .photoLibrary
                self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                self.picker.modalPresentationStyle = .popover
                self.present(self.picker, animated: true, completion: nil)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            
        }))
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
            return self.imagePickerControllerDidCancel(self.picker)
        }
        imageData = image.jpegData(compressionQuality: 0.25)
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    

}
