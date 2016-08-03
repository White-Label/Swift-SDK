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
    
    private let cellIdentifier = "CollectionCell"
    private var paging = PagingGenerator<Collection>(startPage: 1)
    var collections : [Collection] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        paging.next = { page, completion in
            
            WhiteLabel.getCollections(
                parameters: nil,
                page: page,
                success: { collections in
                    completion(objects: collections)
                },
                failure: { error in
                    print("Error getting collections for page \(page): \(error)")
                }
            )
            
        }
        
        // Initial load
        self.getLabel()
        paging.getNext(onFinish: updateDataSource)
    }
    
    func getLabel() {
        
        WhiteLabel.getLabel(
            success: { label in
                self.title = label.name
            },
            failure: { error in
                print("Error retrieving label: \(error)")
            }
        )
        
    }
    
    private func updateDataSource(collections: [Collection]) {
        self.collections += collections
    }
    
    //MARK: Data Source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        let collection = collections[indexPath.row]
        
        cell.textLabel!.text = collection.title;
        cell.detailTextLabel!.text = String(collection.mixtapeCount);
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // Quick and easy infinite scroll trigger
        if indexPath.row == tableView.dataSource!.tableView(tableView, numberOfRowsInSection: indexPath.section) - 2 && collections.count >= WhiteLabel.pageSize {
            paging.getNext(onFinish: updateDataSource)
        }
    }
    
    //MARK: Navigation
    
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
