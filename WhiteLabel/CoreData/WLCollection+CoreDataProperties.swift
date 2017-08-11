//
//  WLCollection+CoreDataProperties.swift
//  Pods
//
//  Created by Alexander Givens on 8/6/17.
//
//

import Foundation
import CoreData


extension WLCollection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WLCollection> {
        return NSFetchRequest<WLCollection>(entityName: "WLCollection")
    }

    @NSManaged public var artworkCredit: String?
    @NSManaged public var artworkCreditURL: String?
    @NSManaged public var artworkURL: String?
    @NSManaged public var created: NSDate?
    @NSManaged public var descriptionText: String?
    @NSManaged public var id: Int32
    @NSManaged public var mixtapeCount: Int32
    @NSManaged public var modified: NSDate?
    @NSManaged public var slug: String?
    @NSManaged public var title: String?

}
