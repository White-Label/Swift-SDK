//
//  WLMixtape+CoreDataClass.swift
//  Pods
//
//  Created by Alexander Givens on 7/20/17.
//
//

import Foundation
import CoreData

@objc(WLMixtape)
public class WLMixtape: NSManagedObject, ResponseObjectSerializable, ResponseCollectionSerializable {

    required public init?(response: HTTPURLResponse, representation: Any) {
        
        guard
            let representation = representation as? [String: Any],
            let id = representation["id"] as? Int32,
            let slug = representation["slug"] as? String,
            let title = representation["title"] as? String,
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
        self.created = created
        self.modified = modified
        
        descriptionText = representation["description"] as? String
        artworkURL = representation["artwork_url"] as? String
        artworkCredit = representation["artwork_credit"] as? String
        artworkCreditURL = representation["artwork_credit_url"] as? String
        sponsor = representation["sponsor"] as? String
        sponsorURL = representation["sponsor_url"] as? String
        product = representation["product"] as? String
        productURL = representation["product_url"] as? String
        
        if let releasedDateString = representation["release"] as? String {
            released = NSDate.dateFrom(string: releasedDateString)
        }
        
        if let trackCount = representation["track_count"] as? Int32 {
            self.trackCount = trackCount
        }
        
    }
    
}
