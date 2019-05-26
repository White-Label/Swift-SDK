//
//  WLService+CoreDataProperties.swift
//  Pods
//
//  Created by Alexander Givens on 8/6/17.
//
//

import Foundation
import CoreData


extension WLService {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WLService> {
        return NSFetchRequest<WLService>(entityName: "WLService")
    }

    @NSManaged public var externalURL: String?
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var slug: String?

}
