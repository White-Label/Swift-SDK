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

    var parentMixtape : WLMixtape!
    var tracks = [WLTrack]()  {
        didSet {
            tableView.reloadData()
        }
    }
    var paging = PagingGenerator(startPage: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = parentMixtape.title
        refreshControl?.addTarget(self, action: #selector(TrackTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        // Setup the paging generator with White Label
        paging.next = { page in
            WhiteLabel.ListTracksInMixtape(self.parentMixtape, page: page, complete: { tracks in
                if tracks != nil {
                    self.tracks += tracks!
                }
            })
        }
        
        paging.getNext() // Initial load
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        paging.reset()
        tracks = []
        paging.getNext() {
            refreshControl.endRefreshing()
        }
    }

    //MARK: Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.Track, for: indexPath)
        let track = tracks[indexPath.row]
        
        cell.textLabel!.text = track.title
        cell.detailTextLabel!.text = track.artist
        
        return cell;
    }
    
    //MARK: Delegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // Quick and easy infinite scroll trigger
        if indexPath.row == tableView.dataSource!.tableView(tableView, numberOfRowsInSection: indexPath.section) - 2 && tracks.count >= Int(WhiteLabel.Constants.PageSize) {
            paging.getNext()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = "Just Add Music 🔊"
        let message = "Now that your networking code is done, check out our NPAudioStream library to start streaming your White Label tracks!"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.cancel, handler: nil));
        alertController.addAction(UIAlertAction(title: "View", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
            UIApplication.shared.openURL(URL(string: "https://github.com/NoonPacific/NPAudioStream")!)
        }));
        
        present(alertController, animated: true, completion: nil)
    }
}

