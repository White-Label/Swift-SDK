//
//  WLService+CoreDataProperties.swift
//  Pods
//
//  Created by Alexander Givens on 7/21/17.
//
//

import Foundation
import CoreData


extension WLService {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WLService> {
        return NSFetchRequest<WLService>(entityName: "WLService")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var slug: String?
    @NSManaged public var externalURL: String?
    @NSManaged public var label: WLLabel?

}
