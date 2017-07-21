//
//  WLService+CoreDataClass.swift
//  Pods
//
//  Created by Alexander Givens on 7/20/17.
//
//

import Foundation
import CoreData

@objc(WLService)
public class WLService: NSManagedObject, ResponseObjectSerializable, ResponseCollectionSerializable {

    required public init?(response: HTTPURLResponse, representation: Any) {
        
        guard
            let representation = representation as? [String: Any],
            let id = representation["id"] as? Int32,
            let slug = representation["slug"] as? String,
            let name = representation["name"] as? String
        else {
            return nil
        }
        
        self.id = id
        self.slug = slug
        self.name = name
        
        externalURL = representation["external_url"] as? String
        
    }
    
}
