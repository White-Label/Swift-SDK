//
//  WLCollection+CoreDataClass.swift
//  Pods
//
//  Created by Alexander Givens on 7/20/17.
//
//

import Foundation
import CoreData

@objc(WLCollection)
final public class WLCollection: NSManagedObject, ResponseObjectSerializable, ResponseCollectionSerializable {

    init?(response: HTTPURLResponse, representation: Any) {
        
        let context = CoreDataStack.sharedStack.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "WLCollection", in: context)!
        super.init(entity: entity, insertInto: context)
        
        guard
            let representation = representation as? [String: Any],
            let id = representation["id"] as? Int32,
            let slug = representation["slug"] as? String,
            let title = representation["title"] as? String /* ,
            let createdDateString = representation["created"] as? String,
            let created = NSDate.dateFrom(string: createdDateString),
            let modifiedDateString = representation["modified"] as? String,
            let modified = NSDate.dateFrom(string: modifiedDateString) */
        else {
            return nil
        }

        self.id = id
        self.slug = slug
        self.title = title
//        self.created = created
//        self.modified = modified

        descriptionText = representation["description"] as? String
        artworkURL = representation["artwork_url"] as? String
        artworkCredit = representation["artwork_credit"] as? String
        artworkCreditURL = representation["artwork_credit_url"] as? String

        if let mixtapeCount = representation["mixtape_count"] as? Int32 {
            self.mixtapeCount = mixtapeCount
        }
    }
    
}
