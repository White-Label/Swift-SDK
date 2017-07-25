//
//  WLTrack+CoreDataClass.swift
//
//  Created by Alex Givens http://alexgivens.com on 7/24/17
//  Copyright © 2017 Noon Pacific LLC http://noonpacific.com
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

import Foundation
import CoreData

@objc(WLTrack)
final public class WLTrack: NSManagedObject, ResponseObjectSerializable, ResponseCollectionSerializable {

    convenience init?(response: HTTPURLResponse, representation: Any) {
        
        let context = CoreDataStack.sharedStack.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "WLTrack", in: context)!
        self.init(entity: entity, insertInto: context)
        
        guard
            let representation = representation as? [String: Any],
            let id = representation["id"] as? Int32,
            let slug = representation["slug"] as? String,
            let title = representation["title"] as? String,
            let artist = representation["artist"] as? String,
            let duration = representation["duration"] as? Int32,
            let order = representation["order"] as? Int32,
            let createdDateString = representation["created"] as? String,
            let created = Date.date(from: createdDateString),
            let modifiedDateString = representation["modified"] as? String,
            let modified = Date.date(from: modifiedDateString)
        else {
            return nil
        }
        
        self.id = id
        self.slug = slug
        self.title = title
        self.artist = artist
        self.duration = duration
        self.created = created as NSDate
        self.modified = modified as NSDate
        self.order = order

        if let externalIDInt = representation["external_id"] as? Int32 {
            self.externalID = "\(externalIDInt)"
        } else if let externalIDString = representation["external_id"] as? String {
            self.externalID = externalIDString
        }
        
        streamURL = representation["stream_url"] as? String
        permalinkURL = representation["permalink_url"] as? String
        artworkURL = representation["artwork_url"] as? String
        purchaseURL = representation["purchase_url"] as? String
        downloadURL = representation["download_url"] as? String
        ticketURL = representation["ticket_url"] as? String
        
        if let playCount = representation["play_count"] as? Int32 {
            self.playCount = playCount
        }
        
    }
    
}
