//
//  CollectionTableViewController.swift
//
//  Created by Alex Givens http://alexgivens.com on 7/28/16
//  Copyright © 2016 Noon Pacific LLC http://noonpacific.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//


import UIKit
import WhiteLabel

class CollectionTableViewController: UITableViewController {
    
    var collections : [Collection] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var paging = PagingGenerator<Collection>(startPage: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(CollectionTableViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        // Get your label
        WhiteLabel.getLabel(
            success: { label in
                self.title = label.name
            },
            failure: { error in
                print("Error: \(error)")
            }
        )
        
        // Setup the paging generator with White Label
        paging.next = { page in
            
            WhiteLabel.getCollections(
                parameters: nil,
                page: page,
                success: { collections in
                    self.collections += collections
                },
                failure: { error in
                    
                    if error.code == -1011 {
                        // If we get a 404 error, stop paging
                        self.paging.reachedEnd()
                    }
                    
                    print("Error: \(error)")
                }
            )
            
        }
        
        paging.getNext() // Initial load
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        paging.reset()
        collections = []
        paging.getNext() {
            refreshControl.endRefreshing()
        }
    }
    
    //MARK: Data Source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.Collection, forIndexPath: indexPath)
        let collection = collections[indexPath.row]
        
        cell.textLabel!.text = collection.title;
        cell.detailTextLabel!.text = String(collection.mixtapeCount);
        
        return cell;
    }
    
    //Mark: Delegate
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // Quick and easy infinite scroll trigger
        if indexPath.row == tableView.dataSource!.tableView(tableView, numberOfRowsInSection: indexPath.section) - 2 && collections.count >= Int(WhiteLabel.pageSize) {
            paging.getNext()
        }
    }
    
    //MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.CollectionsToMixtapes {
            if let mixtapeTableViewController = segue.destinationViewController as? MixtapeTableViewController {
                if let selectedIndexPath = self.tableView.indexPathsForSelectedRows?[0] {
                    mixtapeTableViewController.collection = collections[selectedIndexPath.row]
                }
            }
        }
    }
}
