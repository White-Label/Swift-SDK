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
    
    var collections = [WhiteLabel.Collection]() {
        didSet {
            tableView.reloadData()
        }
    }
    var paging = PagingGenerator(startPage: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(CollectionTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        // Get your label
        WhiteLabel.GetLabel { label in
            self.title = label?.name
        }
        
        // Setup the paging generator with White Label
        paging.next = { page in
            
            WhiteLabel.ListCollections(page: page, parameters: nil, complete: { collections in
                if collections != nil {
                    self.collections += collections!
                }
            })
            
//            WhiteLabel.ListCollections(
//                parameters: nil,
//                page: page,
//                success: { collections in
//                    self.collections += collections
//                },
//                failure: { error in
//                    switch error! {
//                    case .Network(let statusCode, let error):
//                        if statusCode == 404 {
//                            self.paging.reachedEnd()
//                        }
//                        debugPrint("Network Error: \(error)")
//                    case .JSONSerialization(let error):
//                        print("JSONSerialization Error: \(error)")
//                    case .ObjectSerialization(let reason):
//                        print("ObjectSerialization Error Reason: \(reason)")
//                    }
//                }
//            )
            
        }
        
        paging.getNext() // Initial load
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        paging.reset()
        collections = []
        paging.getNext() {
            refreshControl.endRefreshing()
        }
    }
    
    //MARK: Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.Collection, for: indexPath)
        let collection = collections[indexPath.row] as! WhiteLabel.Collection
        
        cell.textLabel!.text = collection.title;
        cell.detailTextLabel!.text = String(collection.mixtapeCount);
        
        return cell;
    }
    
    //Mark: Delegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // Quick and easy infinite scroll trigger
        if indexPath.row == tableView.dataSource!.tableView(tableView, numberOfRowsInSection: indexPath.section) - 2 && collections.count >= Int(WhiteLabel.Constants.PageSize) {
            paging.getNext()
        }
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.CollectionsToMixtapes {
            if let mixtapeTableViewController = segue.destination as? MixtapeTableViewController {
                if let selectedIndexPath = self.tableView.indexPathsForSelectedRows?[0] {
                    mixtapeTableViewController.collection = collections[selectedIndexPath.row]
                }
            }
        }
    }
}
