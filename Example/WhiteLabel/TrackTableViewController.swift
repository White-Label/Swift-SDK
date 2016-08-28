//
//  TrackTableViewController.swift
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

class TrackTableViewController: UITableViewController {

    var mixtape : Mixtape!
    var tracks = [Track]()  {
        didSet {
            tableView.reloadData()
        }
    }
    var paging = PagingGenerator(startPage: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.mixtape.title
        self.refreshControl?.addTarget(self, action: #selector(TrackTableViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        // Setup the paging generator with White Label
        paging.next = { page in
            
            WhiteLabel.ListTracksForMixtape(
                self.mixtape,
                page: page,
                success: { tracks in
                    self.tracks += tracks
                },
                failure: { error in
                    switch error! {
                    case .Network(let statusCode, let error):
                        if statusCode == 404 {
                            self.paging.reachedEnd()
                        }
                        debugPrint("Network Error: \(error)")
                    case .JSONSerialization(let error):
                        print("JSONSerialization Error: \(error)")
                    case .ObjectSerialization(let reason):
                        print("ObjectSerialization Error Reason: \(reason)")
                    }
                }
            )
            
        }
        
        paging.getNext() // Initial load
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        paging.reset()
        tracks = []
        paging.getNext() {
            refreshControl.endRefreshing()
        }
    }

    //MARK: Data Source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.Track, forIndexPath: indexPath)
        let track = tracks[indexPath.row]
        
        cell.textLabel!.text = track.title;
        cell.detailTextLabel!.text = track.artist;
        
        return cell;
    }
    
    //MARK: Delegate
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // Quick and easy infinite scroll trigger
        if indexPath.row == tableView.dataSource!.tableView(tableView, numberOfRowsInSection: indexPath.section) - 2 && tracks.count >= Int(WhiteLabel.PageSize) {
            paging.getNext()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let title = "Just Add Music 🔊"
        let message = "Now that your networking code is done, check out our NPAudioStream library to start streaming your White Label tracks!"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.Cancel, handler: nil));
        alertController.addAction(UIAlertAction(title: "View", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction) in
            UIApplication.sharedApplication().openURL(NSURL(string: "https://github.com/NoonPacific/NPAudioStream")!)
        }));
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

