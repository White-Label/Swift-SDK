//
//  WLLabel+CoreDataClass.swift
//  Pods
//
//  Created by Alexander Givens on 7/20/17.
//
//

import Foundation
import CoreData

@objc(WLLabel)
final public class WLLabel: NSManagedObject, ResponseObjectSerializable, ResponseCollectionSerializable {

    required public init?(response: HTTPURLResponse, representation: Any) {
        
        let context = CoreDataStack.sharedStack.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "WLLabel", in: context)!
        super.init(entity: entity, insertInto: context)
        
        guard
            let representation = representation as? [String: Any],
            let id = representation["id"] as? Int32,
            let slug = representation["slug"] as? String,
            let name = representation["name"] as? String,
            let serviceRepresentation = representation["service"]
        else {
            return nil
        }
        
        self.id = id
        self.slug = slug
        self.name = name
        
        iconURL = representation["icon"] as? String
        
        self.service = WLService(response: response, representation: serviceRepresentation)
    }
    
}
