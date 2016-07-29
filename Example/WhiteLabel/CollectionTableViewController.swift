//
//  CollectionTableViewController.swift
//  WhiteLabel
//
//  Created by Alexander Givens on 07/28/2016.
//  Copyright (c) 2016 Alexander Givens. All rights reserved.
//

import UIKit
import WhiteLabel

class CollectionTableViewController: UITableViewController {
    
    var label : Label?
    var collections : [Collection] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        WhiteLabel.getCollections(
            nil,
            search: nil,
            success: { collections in
                self.collections = collections
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
        return collections.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CollectionCell", forIndexPath: indexPath)
        
        let collection = collections[indexPath.row]
        
        cell.textLabel!.text = collection.title;
        cell.detailTextLabel!.text = collection.slug;
        
        return cell;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CollectionsToMixtapes" {
            if let mixtapeTableViewController = segue.destinationViewController as? MixtapeTableViewController {
                if let selectedIndexPath = self.tableView.indexPathsForSelectedRows?[0] {
                    mixtapeTableViewController.collection = collections[selectedIndexPath.row]
                }
                
            }
        }
    }
}


//CMTracksViewController *tracksTableViewController = (CMTracksViewController *)segue.destinationViewController;
//NSIndexPath *selectedRowIndex = [[self.mixesCollectionView indexPathsForSelectedItems] objectAtIndex:0];
//[tracksTableViewController setMix:(Mix *)[mixesArray objectAtIndex:selectedRowIndex.row]];
//[tracksTableViewController setIsPopup:NO];