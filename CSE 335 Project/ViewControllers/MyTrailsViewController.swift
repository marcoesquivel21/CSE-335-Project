//
//  MyTrailsViewController.swift
//  CSE 335 Project
//
//  Created by Marco Esquivel on 3/21/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import UIKit

class MyTrailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var trailTable: UITableView!
    
    var user:User?
    var curIndex = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user!.hikeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyTrailsTableViewCell
        
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 2
        cell.textLabel?.text = user!.hikeList[indexPath.row].name
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        user!.removeHike(h: user!.hikeList[indexPath.row])
        user!.removeHikeLocal(index: indexPath.row)
        trailTable.reloadData()
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail"{
            let selectedIndex: IndexPath = self.trailTable.indexPath(for: sender as! UITableViewCell)!
            curIndex = selectedIndex.row
            let hike = user!.hikeList[selectedIndex.row]
            let destination = segue.destination as! DetailViewController
            destination.hike = hike
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let selectionIndexPath = self.trailTable.indexPathForSelectedRow {
            self.trailTable.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        trailTable.delegate = self
        trailTable.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backToTable(segue: UIStoryboardSegue){
        if segue.source is DetailViewController{
            let source = segue.source as! DetailViewController
            if source.hike != nil{
                user!.editHikeLocal(index: curIndex, h: source.hike!)
                user!.editHikeDB(h: source.hike!)
                self.trailTable.reloadData()
            }
        }
    }
    

    

}
