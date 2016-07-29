//
//  MixtapeTableViewController.swift
//  WhiteLabel
//
//  Created by Alexander Givens on 7/29/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import WhiteLabel

class MixtapeTableViewController: UITableViewController {

    var collection : Collection?
    var mixtapes : [Mixtape] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
        WhiteLabel.getMixtapes(
            self.collection,
            success: { mixtapes in
                self.mixtapes = mixtapes
                print("Mixtapes \(mixtapes)")
                self.tableView.reloadData()
            },
            failure: { error in
                print("Error retrieving collections")
            }
        )
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mixtapes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MixtapeCell", forIndexPath: indexPath)
        
        let mixtape = mixtapes[indexPath.row]
        
        cell.textLabel!.text = mixtape.title;
        cell.detailTextLabel!.text = mixtape.slug;
        
        return cell;
    }
}
