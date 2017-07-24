//
//  MixtapeTableViewController.swift
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

class MixtapeTableViewController: UITableViewController {

    var collection: WLCollection!
    
    var mixtapes = [WLMixtape]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    let paging = PagingGenerator(startPage: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = collection.title
        refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        
        // Setup the paging generator with White Label
        paging.next = { page, completionMarker in
            
            WhiteLabel.ListMixtapes(inCollection: self.collection, page: page) { result, totalMixtapes in
                switch result {
                    
                case .success(let mixtapes):
                    self.mixtapes += mixtapes
                    if self.mixtapes.count == totalMixtapes {
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
        paging.reset()
        mixtapes.removeAll()
        paging.getNext() {
            refreshControl.endRefreshing()
        }
    }
    
    //MARK: Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mixtapes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.Mixtape, for: indexPath)
        let mixtape = mixtapes[indexPath.row]
        cell.textLabel?.text = mixtape.title
        cell.detailTextLabel?.text = String(mixtape.trackCount)
        return cell
    }
    
    //MARK: Delegate

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if // Quick and easy infinite scroll trigger
            let cellCount = tableView.dataSource?.tableView(tableView, numberOfRowsInSection: indexPath.section),
            indexPath.row == cellCount - 1,
            paging.didReachEnd == false
        {
            paging.getNext()
        }
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            segue.identifier == SegueIdentifier.MixtapesToTracks,
            let trackTableViewController = segue.destination as? TrackTableViewController,
            let selectedIndexPath = tableView.indexPathsForSelectedRows?[0]
        {
            trackTableViewController.mixtape = mixtapes[selectedIndexPath.row]
        }
    }
}
