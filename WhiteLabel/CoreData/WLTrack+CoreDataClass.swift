//
//  WLTrack+CoreDataClass.swift
//  Pods
//
//  Created by Alexander Givens on 7/20/17.
//
//

import Foundation
import CoreData

@objc(WLTrack)
final public class WLTrack: NSManagedObject, ResponseObjectSerializable, ResponseCollectionSerializable {

    required public init?(response: HTTPURLResponse, representation: Any) {
        
        let entity = NSEntityDescription.entity(forEntityName: "WLTrack", in: persistentContainer.viewContext)!
        super.init(entity: entity, insertInto: persistentContainer.viewContext)
        
        guard
            let representation = representation as? [String: Any],
            let id = representation["id"] as? Int32,
            let slug = representation["slug"] as? String,
            let title = representation["title"] as? String,
            let artist = representation["artist"] as? String,
            let duration = representation["duration"] as? Int32,
            let order = representation["order"] as? Int32,
            let createdDateString = representation["created"] as? String,
            let created = NSDate.dateFrom(string: createdDateString),
            let modifiedDateString = representation["modified"] as? String,
            let modified = NSDate.dateFrom(string: modifiedDateString)
        else {
            return nil
        }
        
        self.id = id
        self.slug = slug
        self.title = title
        self.artist = artist
        self.duration = duration
        self.created = created
        self.modified = modified
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
