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
import CoreData
import WhiteLabel

class CollectionTableViewController: UITableViewController {
    
    var fetchedResultsController: NSFetchedResultsController<WLCollection>!
    let paging = PagingGenerator(startPage: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Loading..."
        refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        
        // Get your label
        WhiteLabel.GetLabel { result in
            let label = result.value
            self.title = label?.name
        }
        
        // Clear existing collection cache
        WLCollection.deleteCache()
        
        // Setup fetched results controller
        let request: NSFetchRequest<WLCollection> = WLCollection.fetchRequest()
        let createdSort = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [createdSort]
        let moc = CoreDataStack.sharedStack.managedObjectContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
        // Setup the paging generator with White Label
        paging.next = { page, completionMarker in
            
             WhiteLabel.ListCollections(page: page) { result, totalCollections in
                switch result {
                    
                case .success(let collections):
                    if collections.count < Constants.PageSize {
                        self.paging.reachedEnd()
                    }
                    
                case .failure(let error):
                    debugPrint(error)
                }

                completionMarker()
            }
        }
        
        paging.getNext() // Initial load
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        WLCollection.deleteCache()
        paging.reset()
        paging.getNext() {
            refreshControl.endRefreshing()
        }
    }
    
    // MARK: Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.Collection, for: indexPath)
        let collection = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = collection.title
        cell.detailTextLabel?.text = String(collection.mixtapeCount)
        return cell
    }
    
    // MARK: Delegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if // Quick and easy infinite scroll trigger
            let cellCount = tableView.dataSource?.tableView(tableView, numberOfRowsInSection: indexPath.section),
            indexPath.row == cellCount - 1,
            paging.isFetchingPage == false,
            paging.didReachEnd == false
        {
            paging.getNext()
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            segue.identifier == SegueIdentifier.CollectionsToMixtapes,
            let mixtapeTableViewController = segue.destination as? MixtapeTableViewController,
            let selectedIndexPath = tableView.indexPathsForSelectedRows?[0]
        {
            let collection = fetchedResultsController.object(at: selectedIndexPath)
            mixtapeTableViewController.collection = collection
        }
    }
}

extension CollectionTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
}
